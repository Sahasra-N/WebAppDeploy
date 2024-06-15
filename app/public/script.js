const socket = io('http://localhost:3000');

const isAuthenticated = true; 

if (isAuthenticated) {
    initializeWhiteboard();
} else {
    console.log("User not authenticated.");
}

function initializeWhiteboard() {
    let clickTimeout;
    let clickCount = 0;
    let zIndexCounter = 1; 

    function addStickyNote(color) {
        const note = document.createElement('div');
        note.className = `sticky-note ${color}`;
        note.contentEditable = true;
        note.innerText = 'Write here...';
        note.id = `note-${Date.now()}`;

        const whiteboard = document.querySelector('.box');
        const maxLeft = whiteboard.clientWidth - 150;
        const maxTop = whiteboard.clientHeight - 150;
        note.style.left = `${Math.random() * maxLeft}px`;
        note.style.top = `${Math.random() * maxTop}px`;
        note.style.zIndex = zIndexCounter++; 

        note.draggable = true;
        note.ondragstart = dragStart;
        note.ondragend = dragEnd;
        note.ondblclick = handleNoteDoubleClick;

        document.getElementById('notes-container').appendChild(note);

        socket.emit('addNote', {
            id: note.id,
            color: color,
            content: note.innerText,
            position: {
                left: parseFloat(note.style.left),
                top: parseFloat(note.style.top)
            },
            zIndex: note.style.zIndex
        });
    }

    function handleNoteDoubleClick(event) {
        event.target.remove();

        socket.emit('deleteNote', { noteId: event.target.id });
    }

    function dragStart(event) {
        event.dataTransfer.setData('text/plain', event.target.id);
        setTimeout(() => {
            event.target.style.opacity = '0.5';
        }, 0);
    }

    function dragEnd(event) {
        event.target.style.opacity = '1';
        const whiteboard = document.querySelector('.box');
        const rect = whiteboard.getBoundingClientRect();
        const left = event.clientX - rect.left;
        const top = event.clientY - rect.top;

        const newLeft = Math.max(0, Math.min(left - 75, whiteboard.clientWidth - 150));
        const newTop = Math.max(0, Math.min(top - 75, whiteboard.clientHeight - 150));

        event.target.style.left = `${newLeft}px`;
        event.target.style.top = `${newTop}px`;

        socket.emit('moveNote', {
            noteId: event.target.id,
            position: {
                left: newLeft,
                top: newTop
            }
        });
    }

    socket.on('addNote', (noteData) => {
        const note = document.createElement('div');
        note.className = `sticky-note ${noteData.color}`;
        note.contentEditable = true;
        note.innerText = noteData.content;
        note.id = noteData.id;
        note.style.left = `${noteData.position.left}px`;
        note.style.top = `${noteData.position.top}px`;
        note.style.zIndex = noteData.zIndex;

        note.draggable = true;
        note.ondragstart = dragStart;
        note.ondragend = dragEnd;
        note.ondblclick = handleNoteDoubleClick;

        document.getElementById('notes-container').appendChild(note);
    });

    socket.on('deleteNote', (data) => {
        const noteToDelete = document.getElementById(data.noteId);
        if (noteToDelete) {
            noteToDelete.remove();
        }
    });

    socket.on('moveNote', (data) => {
        const noteToMove = document.getElementById(data.noteId);
        if (noteToMove) {
            noteToMove.style.left = `${data.position.left}px`;
            noteToMove.style.top = `${data.position.top}px`;
        }
    });

    function deleteAllNotes() {
        const notesContainer = document.getElementById('notes-container');
        notesContainer.innerHTML = '';
        zIndexCounter = 1; 

        socket.emit('deleteAllNotes');
    }

    socket.on('deleteAllNotes', () => {
        deleteAllNotes();
    });

    document.querySelector('.box').ondragover = (event) => {
        event.preventDefault();
    };

    document.getElementById('addRedNote').addEventListener('click', () => addStickyNote('red'));
    document.getElementById('addBlueNote').addEventListener('click', () => addStickyNote('blue'));
    document.getElementById('addGreenNote').addEventListener('click', () => addStickyNote('green'));
    document.getElementById('addYellowNote').addEventListener('click', () => addStickyNote('yellow'));
    document.getElementById('addPinkNote').addEventListener('click', () => addStickyNote('pink'));
    document.getElementById('addPurpleNote').addEventListener('click', () => addStickyNote('purple'));
    document.getElementById('deleteAllNotes').addEventListener('click', deleteAllNotes);
}
