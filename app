```react
import React, { useState, useEffect, useRef } from 'react';

// --- SYSTEM CONSTANTS & PRESETS ---
const DEFAULT_FOLDERS = ['🌾 Grazing Logs', '🧗 Mountain Climbs', '💼 Daily Barn', '🍎 Sweet Treats', '✨ Sandbox'];
const NOTE_COLORS = [
  { name: 'Alpine Charcoal', bg: 'bg-slate-900 border-slate-700', text: 'text-slate-100', dot: 'bg-slate-500' },
  { name: 'Meadow Sage', bg: 'bg-emerald-950/90 border-emerald-800', text: 'text-emerald-100', dot: 'bg-emerald-500' },
  { name: 'Alfalfa Gold', bg: 'bg-amber-950/90 border-amber-800', text: 'text-amber-100', dot: 'bg-amber-500' },
  { name: 'Clover Violet', bg: 'bg-indigo-950/90 border-indigo-800', text: 'text-indigo-100', dot: 'bg-indigo-500' },
  { name: 'Saltlick Crimson', bg: 'bg-rose-950/90 border-rose-800', text: 'text-rose-100', dot: 'bg-rose-500' },
];

const INITIAL_NOTES = [
  {
    id: '1',
    title: 'Welcome to Goat Note! 🐐',
    content: `## The Greatest of All Time Note App

Welcome! **Goat Note** is built for nimble thinkers who want to scale high cliffs of productivity.

### Key Features:
1. **Folders & Tags**: Keep your meadow organized.
2. **Color Coding**: Highlight notes for quick discovery.
3. **Sound Effects**: Click the sound button or complete notes to hear simulated goat bleats!
4. **G.O.A.T. AI Translator**: Try the panel on the right to translate normal notes into literal "Goat Speak" (Baaaa!) or motivational "G.O.A.T. Coach" speeches.

*Grab life by the horns and start typing!*`,
    folder: '✨ Sandbox',
    color: 'bg-emerald-950/90 border-emerald-800',
    colorName: 'Meadow Sage',
    isPinned: true,
    isArchived: false,
    updatedAt: new Date(Date.now() - 3600000).toISOString(),
    tags: ['welcome', 'guide']
  },
  {
    id: '2',
    title: 'Top Sweet Grass Locations 🌾',
    content: `- North face of Mt. Everest (hard climb, excellent flavor)
- The local farmer's front yard (dangerous dog, proceed with high stealth)
- Hydroponic clover patch under the big oak tree

*Todo: Buy climbing rope and a custom grass satchel.*`,
    folder: '🌾 Grazing Logs',
    color: 'bg-amber-950/90 border-amber-800',
    colorName: 'Alfalfa Gold',
    isPinned: false,
    isArchived: false,
    updatedAt: new Date(Date.now() - 7200000).toISOString(),
    tags: ['grazing', 'climbing']
  }
];

export default function App() {
  // --- STATE ---
  const [notes, setNotes] = useState(() => {
    // We'll fall back to initial notes if nothing is found (or on first boot)
    return INITIAL_NOTES;
  });
  
  const [activeNoteId, setActiveNoteId] = useState('1');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFolder, setSelectedFolder] = useState('All'); // 'All' | 'Pinned' | 'Archived' | folder name
  const [selectedTag, setSelectedTag] = useState('All');
  
  // Note Form Editor States
  const [editTitle, setEditTitle] = useState('');
  const [editContent, setEditContent] = useState('');
  const [editFolder, setEditFolder] = useState('✨ Sandbox');
  const [editColor, setEditColor] = useState(NOTE_COLORS[0]);
  const [editTags, setEditTags] = useState('');
  
  // Custom Modal / Alert Notification State (No browser alerts allowed)
  const [notification, setNotification] = useState(null);
  const [showNewFolderModal, setShowNewFolderModal] = useState(false);
  const [newFolderName, setNewFolderName] = useState('');
  const [folders, setFolders] = useState(DEFAULT_FOLDERS);

  // View Mode for Mobile Layout Responsiveness
  const [mobileView, setMobileView] = useState('list'); // 'list' | 'editor'

  // Goat Translator State
  const [translatorMode, setTranslatorMode] = useState('literal'); // 'literal' | 'coach'
  const [translatedText, setTranslatedText] = useState('');
  const [isTranslating, setIsTranslating] = useState(false);

  const activeNote = notes.find(n => n.id === activeNoteId);

  // Sync editor fields with the active note
  useEffect(() => {
    if (activeNote) {
      setEditTitle(activeNote.title);
      setEditContent(activeNote.content);
      setEditFolder(activeNote.folder || '✨ Sandbox');
      const currentColor = NOTE_COLORS.find(c => c.bg === activeNote.color) || NOTE_COLORS[0];
      setEditColor(currentColor);
      setEditTags(activeNote.tags ? activeNote.tags.join(', ') : '');
      setTranslatedText(''); // Clear translation on note switch
    } else {
      setEditTitle('');
      setEditContent('');
      setEditFolder('✨ Sandbox');
      setEditColor(NOTE_COLORS[0]);
      setEditTags('');
      setTranslatedText('');
    }
  }, [activeNoteId]);

  // --- SHOW CUSTOM TEMPORARY NOTIFICATION ---
  const triggerNotification = (message, type = 'success') => {
    setNotification({ message, type });
    setTimeout(() => {
      setNotification(null);
    }, 3000);
  };

  // --- AUDIO SYNTHESIS: THE GOAT BLEAT ---
  const playBleat = () => {
    try {
      const AudioContextClass = window.AudioContext || window.webkitAudioContext;
      const ctx = new AudioContextClass();
      
      const mainOsc = ctx.createOscillator();
      const modulationOsc = ctx.createOscillator();
      const modGain = ctx.createGain();
      const mainGain = ctx.createGain();

      // Set up frequency sweep for classic goat-like wavering pitch
      mainOsc.frequency.setValueAtTime(260, ctx.currentTime); // Pitch base
      mainOsc.frequency.exponentialRampToValueAtTime(320, ctx.currentTime + 0.15);
      mainOsc.frequency.exponentialRampToValueAtTime(190, ctx.currentTime + 0.7);

      // Low frequency vibrato for the goat "shaking" vocal character
      modulationOsc.frequency.setValueAtTime(14, ctx.currentTime); 
      modGain.gain.setValueAtTime(35, ctx.currentTime); // Depth of pitch wobble

      // Audio route connections
      modulationOsc.connect(modGain);
      modGain.connect(mainOsc.frequency);
      mainOsc.connect(mainGain);
      mainGain.connect(ctx.destination);

      // Volume envelope (quick rise, wavering hold, rapid decay)
      mainGain.gain.setValueAtTime(0.01, ctx.currentTime);
      mainGain.gain.linearRampToValueAtTime(0.3, ctx.currentTime + 0.05);
      mainGain.gain.setValueAtTime(0.3, ctx.currentTime + 0.3);
      mainGain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.75);

      // Start synthesizers
      modulationOsc.start();
      mainOsc.start();

      // Stop audio nodes
      modulationOsc.stop(ctx.currentTime + 0.8);
      mainOsc.stop(ctx.currentTime + 0.8);

      triggerNotification("🐐 Mmm-baaaa! Bleat trigger active!");
    } catch (e) {
      console.warn("Audio Context blocked or unsupported:", e);
    }
  };

  // --- ACTIONS ---

  // 1. Create Note
  const handleCreateNote = () => {
    const newNote = {
      id: Date.now().toString(),
      title: 'Untamed Draft Note 📝',
      content: 'Write down your peak strategies here...',
      folder: folders[0] || '✨ Sandbox',
      color: NOTE_COLORS[0].bg,
      colorName: NOTE_COLORS[0].name,
      isPinned: false,
      isArchived: false,
      updatedAt: new Date().toISOString(),
      tags: ['new']
    };
    setNotes([newNote, ...notes]);
    setActiveNoteId(newNote.id);
    setMobileView('editor');
    triggerNotification("Created a fresh new note!");
  };

  // 2. Save Active Note Updates
  const handleSaveActiveNote = () => {
    if (!activeNoteId) return;
    
    // Parse tags string
    const processedTags = editTags
      .split(',')
      .map(t => t.trim().toLowerCase())
      .filter(t => t.length > 0);

    const updated = notes.map(note => {
      if (note.id === activeNoteId) {
        return {
          ...note,
          title: editTitle.trim() || 'Untitled Note',
          content: editContent,
          folder: editFolder,
          color: editColor.bg,
          colorName: editColor.name,
          tags: processedTags,
          updatedAt: new Date().toISOString()
        };
      }
      return note;
    });

    setNotes(updated);
    triggerNotification("Note synced to your mountain vault!");
  };

  // Auto-save changes dynamically with a small delay simulation or simple effect
  useEffect(() => {
    if (!activeNoteId) return;
    const delayDebounce = setTimeout(() => {
      // Auto-save quietly
      setNotes(prevNotes => prevNotes.map(n => {
        if (n.id === activeNoteId) {
          const processedTags = editTags
            .split(',')
            .map(t => t.trim().toLowerCase())
            .filter(t => t.length > 0);

          return {
            ...n,
            title: editTitle.trim() || 'Untitled Note',
            content: editContent,
            folder: editFolder,
            color: editColor.bg,
            colorName: editColor.name,
            tags: processedTags,
            updatedAt: new Date().toISOString()
          };
        }
        return n;
      }));
    }, 800);

    return () => clearTimeout(delayDebounce);
  }, [editTitle, editContent, editFolder, editColor, editTags]);

  // 3. Delete Note
  const handleDeleteNote = (id) => {
    const remaining = notes.filter(n => n.id !== id);
    setNotes(remaining);
    if (activeNoteId === id) {
      setActiveNoteId(remaining[0]?.id || null);
    }
    triggerNotification("Note sent back to the elements.", "warning");
    setMobileView('list');
  };

  // 4. Toggle Pin
  const handleTogglePin = (id) => {
    setNotes(notes.map(n => {
      if (n.id === id) {
        const nextState = !n.isPinned;
        triggerNotification(nextState ? "Pinned note to the top summit!" : "Unpinned note.");
        return { ...n, isPinned: nextState };
      }
      return n;
    }));
  };

  // 5. Toggle Archive
  const handleToggleArchive = (id) => {
    setNotes(notes.map(n => {
      if (n.id === id) {
        const nextState = !n.isArchived;
        triggerNotification(nextState ? "Archived note." : "Restored note to meadow.");
        return { ...n, isArchived: nextState };
      }
      return n;
    }));
  };

  // 6. Add Custom Folder
  const handleAddFolder = (e) => {
    e.preventDefault();
    const formatted = newFolderName.trim();
    if (formatted && !folders.includes(formatted)) {
      setFolders([...folders, `⛰️ ${formatted}`]);
      setNewFolderName('');
      setShowNewFolderModal(false);
      triggerNotification(`New pasture created: ${formatted}`);
    }
  };

  // --- G.O.A.T AI TRANSLATOR FEATURE ---
  const handleGoatTranslation = () => {
    if (!editContent) {
      triggerNotification("Your note is empty, nothing to translate!", "warning");
      return;
    }
    setIsTranslating(true);
    
    setTimeout(() => {
      if (translatorMode === 'literal') {
        // Translate into funny literal Baaa-speak
        const sentences = editContent.split(/[.!?]+/);
        const goatSentences = sentences.map(sentence => {
          if (!sentence.trim()) return '';
          const modifiers = ['Baaaa!', 'Munch munch...', 'Pffft!', 'Bleeeeat!', 'G.O.A.T.', '*eats paper note*'];
          const randomMod = modifiers[Math.floor(Math.random() * modifiers.length)];
          const words = sentence.trim().split(' ');
          const replacedWords = words.map((w, index) => {
            if (index % 3 === 0) return 'baaa';
            if (index % 5 === 0) return 'grass';
            return w;
          });
          return `${randomMod} ${replacedWords.join(' ')}`;
        }).filter(s => s.length > 0);

        setTranslatedText(goatSentences.join('. ') + '... BAAAA!');
      } else {
        // Professional High Achiever / Motivational Goat speak
        const highAchieverPhrases = [
          "📈 SCALE THE CLIFFS: No peak is too steep for the ultimate G.O.A.T.!",
          "💪 ELITE GRAZING MATRIX: Eliminate the low-quality weeds. Focus purely on high-yield Alfalfa clover.",
          "🐐 GREATEST OF ALL TIME MINDSET: When others get stuck in the valley, we leap across the chasms of procrastination.",
          "🛡️ UNBREAKABLE HORNS: Ram straight through your daily targets. No compromise."
        ];
        const randomPhrase1 = highAchieverPhrases[Math.floor(Math.random() * highAchieverPhrases.length)];
        const randomPhrase2 = highAchieverPhrases[(Math.floor(Math.random() * highAchieverPhrases.length) + 1) % highAchieverPhrases.length];

        setTranslatedText(`### 🐐 G.O.A.T Coach Analysis Summary\n\n"${editTitle || 'Your Current Goal'}" demands aggressive, peak-climbing energy.\n\n**Actionable Directives:**\n- ${randomPhrase1}\n- ${randomPhrase2}\n\n*Execute now and bleat proudly!*`);
      }
      setIsTranslating(false);
      playBleat();
    }, 1200);
  };

  // --- FILTERED AND SORTED NOTES LIST ---
  const allUniqueTags = Array.from(new Set(notes.flatMap(n => n.tags || [])));

  const filteredNotes = notes.filter(note => {
    // 1. Search filter
    const matchesSearch = 
      note.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      note.content.toLowerCase().includes(searchQuery.toLowerCase());
    
    // 2. Folder sidebar selection filter
    let matchesFolder = true;
    if (selectedFolder === 'Pinned') {
      matchesFolder = note.isPinned && !note.isArchived;
    } else if (selectedFolder === 'Archived') {
      matchesFolder = note.isArchived;
    } else if (selectedFolder !== 'All') {
      matchesFolder = note.folder === selectedFolder && !note.isArchived;
    } else {
      // Default 'All' folder hides archived notes by default
      matchesFolder = !note.isArchived;
    }

    // 3. Tag pill filter
    let matchesTag = true;
    if (selectedTag !== 'All') {
      matchesTag = note.tags && note.tags.includes(selectedTag);
    }

    return matchesSearch && matchesFolder && matchesTag;
  });

  // Sort notes: pinned notes first, then ordered by most recently updated
  const sortedNotes = [...filteredNotes].sort((a, b) => {
    if (a.isPinned && !b.isPinned) return -1;
    if (!a.isPinned && b.isPinned) return 1;
    return new Date(b.updatedAt) - new Date(a.updatedAt);
  });

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-emerald-500 selection:text-slate-900">
      
      {/* GLOBAL SYSTEM NOTIFICATION BANNER */}
      {notification && (
        <div className="fixed bottom-6 right-6 z-50 flex items-center gap-3 bg-slate-900 border border-emerald-500/30 text-emerald-300 px-5 py-4 rounded-xl shadow-2xl animate-bounce backdrop-blur-md">
          <span className="text-xl">🔔</span>
          <span className="text-sm font-semibold tracking-wide">{notification.message}</span>
        </div>
      )}

      {/* NEW PASTURE (FOLDER) DIALOG MODAL */}
      {showNewFolderModal && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center p-4">
          <form 
            onSubmit={handleAddFolder} 
            className="bg-slate-900 border border-slate-800 rounded-2xl p-6 w-full max-w-sm flex flex-col gap-4 shadow-2xl animate-scaleIn"
          >
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-bold text-slate-100">Create New Pasture</h3>
              <button 
                type="button" 
                onClick={() => setShowNewFolderModal(false)}
                className="text-slate-400 hover:text-slate-200"
              >
                ✕
              </button>
            </div>
            <p className="text-xs text-slate-400">
              Set up a isolated area of focus to categorize and herd your climbing notes.
            </p>
            <input
              type="text"
              placeholder="e.g. Backyard Shrubbery, Tech Stack"
              required
              value={newFolderName}
              onChange={(e) => setNewFolderName(e.target.value)}
              className="bg-slate-950 border border-slate-800 focus:border-emerald-500 rounded-lg px-4 py-3 text-sm text-slate-100 outline-none w-full font-mono transition"
            />
            <div className="flex justify-end gap-2 mt-2">
              <button
                type="button"
                onClick={() => setShowNewFolderModal(false)}
                className="px-4 py-2 text-xs font-bold text-slate-400 hover:text-slate-200 transition"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="px-5 py-2.5 text-xs font-bold bg-emerald-600 hover:bg-emerald-500 text-slate-950 rounded-lg transition"
              >
                Fertilize Pasture 🌾
              </button>
            </div>
          </form>
        </div>
      )}

      {/* NAVIGATION BAR HEADER */}
      <header className="border-b border-slate-900 bg-slate-900/60 backdrop-blur-md sticky top-0 z-40 px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          {/* Cute Customized Goat Vector Icon */}
          <div className="p-2.5 rounded-xl bg-gradient-to-tr from-emerald-500 to-emerald-400 text-slate-950 shadow-lg shadow-emerald-500/10">
            <svg className="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M16 18c0-1.1-.9-2-2-2h-4c-1.1 0-2 .9-2 2" />
              <path d="M12 2v4" />
              <path d="M9 3c0 2-1 4-3 5" />
              <path d="M15 3c0 2 1 4 3 5" />
              <rect x="8" y="6" width="8" height="10" rx="2" />
              <circle cx="10" cy="11" r="1" />
              <circle cx="14" cy="11" r="1" />
            </svg>
          </div>
          <div>
            <div className="flex items-center gap-1.5">
              <h1 className="text-xl font-extrabold tracking-tight bg-gradient-to-r from-emerald-400 via-teal-400 to-amber-300 bg-clip-text text-transparent">
                GOAT NOTE
              </h1>
              <span className="bg-emerald-950 text-emerald-400 text-[10px] font-bold px-1.5 py-0.5 rounded border border-emerald-800/60 font-mono tracking-widest">
                G.O.A.T
              </span>
            </div>
            <p className="text-[10px] text-slate-400 font-mono tracking-wider">The Greatest of All Time Workspace</p>
          </div>
        </div>

        {/* Global Toolbar */}
        <div className="flex items-center gap-2">
          {/* Simulated Bleat Sound Board Button */}
          <button
            onClick={playBleat}
            title="Celebrate productivity with a simulated Goat sound"
            className="flex items-center gap-2 text-xs font-bold font-mono px-4 py-2.5 rounded-lg bg-slate-900 border border-slate-800 text-slate-300 hover:text-emerald-400 hover:border-emerald-500/40 transition duration-150"
          >
            <span>📢</span>
            <span className="hidden sm:inline">BLEAT FEEDBACK</span>
          </button>
          
          {/* Quick Create Note Button */}
          <button
            onClick={handleCreateNote}
            className="flex items-center gap-1 px-4 py-2.5 bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-bold text-xs rounded-lg shadow-lg hover:shadow-emerald-500/10 tracking-wide transition duration-150"
          >
            <span className="text-base font-bold">+</span>
            <span>NEW NOTE</span>
          </button>
        </div>
      </header>

      {/* THREE-COLUMN WORKSPACE WRAPPER */}
      <div className="flex-grow flex flex-col md:flex-row max-w-full overflow-hidden">
        
        {/* ========================================================
            COLUMN 1: SIDEBAR DIRECTORY FOLDERS & STATUS (Static on md+)
            ======================================================== */}
        <aside className="w-full md:w-64 border-r border-slate-900 bg-slate-950 p-4 shrink-0 flex flex-col gap-6">
          
          {/* Pasture / Folders Navigation */}
          <div className="flex flex-col gap-2">
            <div className="flex justify-between items-center px-2 py-1">
              <span className="text-xs font-bold tracking-wider text-slate-400 uppercase font-mono">Pastures</span>
              <button 
                onClick={() => setShowNewFolderModal(true)}
                title="Add New Folder Pasture" 
                className="text-slate-500 hover:text-emerald-400 text-sm font-semibold p-1 hover:bg-slate-900 rounded"
              >
                +
              </button>
            </div>
            
            <div className="flex flex-col gap-1">
              <button
                onClick={() => { setSelectedFolder('All'); setSelectedTag('All'); }}
                className={`flex items-center justify-between px-3 py-2.5 rounded-lg text-xs font-bold font-mono transition ${
                  selectedFolder === 'All' && selectedTag === 'All'
                    ? 'bg-emerald-950/50 text-emerald-400 border border-emerald-800/40 shadow-inner'
                    : 'text-slate-400 hover:bg-slate-900/60 hover:text-slate-200'
                }`}
              >
                <span>🌍 Whole Pasture</span>
                <span className="bg-slate-900 px-2 py-0.5 rounded text-[10px] border border-slate-800">
                  {notes.filter(n => !n.isArchived).length}
                </span>
              </button>

              <button
                onClick={() => { setSelectedFolder('Pinned'); setSelectedTag('All'); }}
                className={`flex items-center justify-between px-3 py-2.5 rounded-lg text-xs font-bold font-mono transition ${
                  selectedFolder === 'Pinned'
                    ? 'bg-emerald-950/50 text-emerald-400 border border-emerald-800/40 shadow-inner'
                    : 'text-slate-400 hover:bg-slate-900/60 hover:text-slate-200'
                }`}
              >
                <span>📌 High Summit (Pinned)</span>
                <span className="bg-slate-900 px-2 py-0.5 rounded text-[10px] border border-slate-800">
                  {notes.filter(n => n.isPinned && !n.isArchived).length}
                </span>
              </button>

              {/* User Folders pasture dynamic list */}
              <div className="h-px bg-slate-900 my-1"></div>

              {folders.map(folderName => (
                <button
                  key={folderName}
                  onClick={() => { setSelectedFolder(folderName); setSelectedTag('All'); }}
                  className={`flex items-center justify-between px-3 py-2.5 rounded-lg text-xs font-medium font-mono transition ${
                    selectedFolder === folderName
                      ? 'bg-emerald-950/50 text-emerald-400 border border-emerald-800/40 shadow-inner'
                      : 'text-slate-400 hover:bg-slate-900/60 hover:text-slate-200'
                  }`}
                >
                  <span className="truncate">{folderName}</span>
                  <span className="bg-slate-900 px-2 py-0.5 rounded text-[10px] border border-slate-800 shrink-0 ml-2">
                    {notes.filter(n => n.folder === folderName && !n.isArchived).length}
                  </span>
                </button>
              ))}

              <div className="h-px bg-slate-900 my-1"></div>

              <button
                onClick={() => { setSelectedFolder('Archived'); setSelectedTag('All'); }}
                className={`flex items-center justify-between px-3 py-2.5 rounded-lg text-xs font-bold font-mono transition ${
                  selectedFolder === 'Archived'
                    ? 'bg-emerald-950/50 text-emerald-400 border border-emerald-800/40 shadow-inner'
                    : 'text-slate-400 hover:bg-slate-900/60 hover:text-slate-200'
                }`}
              >
                <span>📦 Forgotten Hay (Archive)</span>
                <span className="bg-slate-900 px-2 py-0.5 rounded text-[10px] border border-slate-800">
                  {notes.filter(n => n.isArchived).length}
                </span>
              </button>
            </div>
          </div>

          {/* Tag Cloud Filter */}
          {allUniqueTags.length > 0 && (
            <div className="flex flex-col gap-2">
              <span className="text-xs font-bold tracking-wider text-slate-400 uppercase font-mono px-2">Herb Tags</span>
              <div className="flex flex-wrap gap-1.5 p-1">
                <button
                  onClick={() => setSelectedTag('All')}
                  className={`text-[10px] font-bold font-mono px-2 py-1 rounded transition ${
                    selectedTag === 'All'
                      ? 'bg-emerald-500 text-slate-950'
                      : 'bg-slate-900 text-slate-400 hover:text-slate-200'
                  }`}
                >
                  # all-grazes
                </button>
                {allUniqueTags.map(tag => (
                  <button
                    key={tag}
                    onClick={() => setSelectedTag(tag)}
                    className={`text-[10px] font-bold font-mono px-2 py-1 rounded transition ${
                      selectedTag === tag
                        ? 'bg-emerald-500 text-slate-950'
                        : 'bg-slate-900 text-slate-400 hover:text-slate-200'
                    }`}
                  >
                    #{tag}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Herd Statistics Card */}
          <div className="mt-auto bg-slate-900/40 border border-slate-900 p-4 rounded-xl flex flex-col gap-3 font-mono">
            <span className="text-[10px] text-slate-500 tracking-widest font-extrabold uppercase">HERD STATISTICS</span>
            
            <div className="grid grid-cols-2 gap-3 text-center">
              <div className="bg-slate-950 p-2 rounded-lg border border-slate-900">
                <div className="text-lg font-black text-emerald-400">{notes.length}</div>
                <div className="text-[9px] text-slate-500">Total Notes</div>
              </div>
              <div className="bg-slate-950 p-2 rounded-lg border border-slate-900">
                <div className="text-lg font-black text-amber-500">
                  {notes.reduce((sum, n) => sum + (n.content?.split(/\s+/).length || 0), 0)}
                </div>
                <div className="text-[9px] text-slate-500">Words Grazed</div>
              </div>
            </div>

            {/* Custom Interactive Motivation Level Bar */}
            <div className="flex flex-col gap-1 text-[10px] text-slate-400">
              <div className="flex justify-between font-bold">
                <span>Goat Energy Level</span>
                <span className="text-emerald-400">
                  {Math.min(100, notes.length * 15 + 40)}%
                </span>
              </div>
              <div className="w-full bg-slate-950 h-2 rounded overflow-hidden border border-slate-900">
                <div 
                  className="bg-gradient-to-r from-emerald-500 to-amber-400 h-full transition-all duration-500" 
                  style={{ width: `${Math.min(100, notes.length * 15 + 40)}%` }}
                />
              </div>
            </div>
          </div>
        </aside>

        {/* ========================================================
            COLUMN 2: NOTES LIST (Visible or toggleable via mobile state)
            ======================================================== */}
        <section className={`w-full md:w-80 border-r border-slate-900 bg-slate-950 flex flex-col shrink-0 ${
          mobileView === 'editor' ? 'hidden md:flex' : 'flex'
        }`}>
          
          {/* Quick Search Header */}
          <div className="p-4 border-b border-slate-900 flex flex-col gap-2">
            <div className="relative">
              <input
                type="text"
                placeholder="Search draft content..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full bg-slate-900 border border-slate-800 rounded-lg pl-9 pr-4 py-2 text-xs text-slate-200 placeholder-slate-500 outline-none focus:border-emerald-500 transition"
              />
              <span className="absolute left-3.5 top-2.5 text-xs text-slate-500">🔍</span>
              {searchQuery && (
                <button 
                  onClick={() => setSearchQuery('')}
                  className="absolute right-3 top-2 text-xs text-slate-500 hover:text-slate-300"
                >
                  ✕
                </button>
              )}
            </div>

            {/* Path Breadcrumb indicator */}
            <div className="flex items-center justify-between text-[10px] text-slate-500 font-mono px-1">
              <span>Pasture: <strong className="text-slate-300">{selectedFolder}</strong></span>
              <span>Sorted by Recent</span>
            </div>
          </div>

          {/* Notes Dynamic Feed */}
          <div className="flex-grow overflow-y-auto p-3 flex flex-col gap-2.5">
            {sortedNotes.length === 0 ? (
              <div className="text-center py-12 px-4 flex flex-col items-center gap-2">
                <span className="text-3xl">📭</span>
                <span className="text-xs text-slate-400 font-mono">No drafts found in this pasture.</span>
                <button
                  onClick={handleCreateNote}
                  className="text-xs text-emerald-400 font-bold underline hover:text-emerald-300 mt-1"
                >
                  Create a Note Now
                </button>
              </div>
            ) : (
              sortedNotes.map(note => {
                const isActive = note.id === activeNoteId;
                const dateString = new Date(note.updatedAt).toLocaleDateString(undefined, {
                  month: 'short',
                  day: 'numeric'
                });
                
                // Get clean excerpt preview of note content
                const cleanExcerpt = note.content
                  ? note.content.replace(/[#*`\-]/g, '').slice(0, 70) + (note.content.length > 70 ? '...' : '')
                  : 'Blank meadow draft...';

                return (
                  <div
                    key={note.id}
                    onClick={() => {
                      setActiveNoteId(note.id);
                      setMobileView('editor');
                    }}
                    className={`p-3.5 rounded-xl border cursor-pointer flex flex-col gap-2 transition duration-200 relative ${
                      isActive 
                        ? 'bg-slate-900 border-emerald-500/50 shadow-lg shadow-emerald-500/5' 
                        : 'bg-slate-900/40 border-slate-900 hover:border-slate-800'
                    }`}
                  >
                    {/* Color dot category indicator */}
                    <div className="absolute left-2.5 top-4 w-1.5 h-1.5 rounded-full bg-emerald-500" />

                    <div className="flex justify-between items-start pl-2">
                      <h4 className="text-xs font-bold text-slate-200 line-clamp-1 flex-grow pr-2">
                        {note.title}
                      </h4>
                      <div className="flex gap-1 items-center shrink-0">
                        {note.isPinned && (
                          <span title="Pinned to high summit" className="text-[10px]">📌</span>
                        )}
                        <span className="text-[9px] text-slate-500 font-mono">{dateString}</span>
                      </div>
                    </div>

                    <p className="text-[11px] text-slate-400 line-clamp-2 leading-relaxed pl-2">
                      {cleanExcerpt}
                    </p>

                    <div className="flex justify-between items-center mt-1 pl-2">
                      <span className="text-[9px] text-slate-500 bg-slate-950 px-1.5 py-0.5 rounded border border-slate-900 truncate max-w-[120px]">
                        {note.folder}
                      </span>
                      
                      {/* Mini Tag Display List */}
                      {note.tags && note.tags.length > 0 && (
                        <div className="flex gap-1 truncate max-w-[100px]">
                          {note.tags.slice(0, 2).map(tag => (
                            <span key={tag} className="text-[8px] font-mono text-emerald-400 bg-emerald-950/20 px-1 py-0.2 rounded">
                              #{tag}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                );
              })
            )}
          </div>

          {/* Quick Stats banner */}
          <div className="p-3 bg-slate-900/20 border-t border-slate-900 text-center text-[10px] text-slate-500 font-mono">
            Feed Count: {sortedNotes.length} matching G.O.A.T logs
          </div>
        </section>

        {/* ========================================================
            COLUMN 3: CENTRAL RICH EDITOR & G.O.A.T CO-PILOT
            ======================================================== */}
        <section className={`flex-grow flex flex-col bg-slate-900/20 ${
          mobileView === 'list' ? 'hidden md:flex' : 'flex'
        }`}>
          {activeNote ? (
            <div className="flex-grow flex flex-col xl:flex-row overflow-hidden">
              
              {/* Primary Editor Workspace Area */}
              <div className="flex-grow flex flex-col p-4 md:p-6 overflow-y-auto border-r border-slate-950">
                
                {/* Editor Responsive Top Menu Bar */}
                <div className="flex items-center justify-between gap-4 border-b border-slate-900 pb-4 mb-4">
                  {/* Back to List on mobile layout */}
                  <button
                    onClick={() => setMobileView('list')}
                    className="md:hidden flex items-center gap-1.5 text-xs text-slate-400 hover:text-slate-100 py-1.5 px-3 rounded-lg bg-slate-900 border border-slate-800"
                  >
                    <span>⬅</span>
                    <span>Back to Meadow</span>
                  </button>

                  <div className="flex gap-2 items-center">
                    {/* Color indicator dropdown picker */}
                    <span className="text-xs text-slate-500 font-mono hidden lg:inline">Note Outfit:</span>
                    <div className="flex gap-1.5">
                      {NOTE_COLORS.map(colorPreset => (
                        <button
                          key={colorPreset.name}
                          onClick={() => setEditColor(colorPreset)}
                          title={`Color code: ${colorPreset.name}`}
                          className={`w-5 h-5 rounded-full border-2 transition-transform duration-100 ${colorPreset.bg} ${
                            editColor.bg === colorPreset.bg ? 'border-slate-100 scale-125' : 'border-transparent hover:scale-110'
                          }`}
                        />
                      ))}
                    </div>
                  </div>

                  {/* Actions buttons for Current Note */}
                  <div className="flex gap-1">
                    <button
                      onClick={() => handleTogglePin(activeNote.id)}
                      title={activeNote.isPinned ? "Unpin Note" : "Pin Note to Summit"}
                      className={`p-2 rounded-lg text-xs font-bold transition duration-150 ${
                        activeNote.isPinned 
                          ? 'bg-amber-500/20 text-amber-400 border border-amber-500/30' 
                          : 'bg-slate-900 border border-slate-800 hover:border-slate-700 text-slate-400'
                      }`}
                    >
                      📌 {activeNote.isPinned ? 'Pinned' : 'Pin'}
                    </button>
                    
                    <button
                      onClick={() => handleToggleArchive(activeNote.id)}
                      title={activeNote.isArchived ? "Restore Note" : "Archive Note"}
                      className={`p-2 rounded-lg text-xs font-bold transition duration-150 ${
                        activeNote.isArchived 
                          ? 'bg-purple-500/20 text-purple-400 border border-purple-500/30' 
                          : 'bg-slate-900 border border-slate-800 hover:border-slate-700 text-slate-400'
                      }`}
                    >
                      📦 {activeNote.isArchived ? 'Archived' : 'Archive'}
                    </button>

                    <button
                      onClick={() => handleDeleteNote(activeNote.id)}
                      title="Erase Note permanently"
                      className="p-2 bg-slate-900 border border-slate-800 hover:bg-rose-950 hover:text-rose-400 hover:border-rose-500/20 text-slate-400 rounded-lg text-xs transition duration-150"
                    >
                      🗑️ Erase
                    </button>
                  </div>
                </div>

                {/* Form Inputs Container */}
                <div className="flex flex-col gap-4">
                  {/* Title Input */}
                  <input
                    type="text"
                    value={editTitle}
                    onChange={(e) => setEditTitle(e.target.value)}
                    placeholder="Enter Note Title..."
                    className="bg-transparent border-none focus:ring-0 text-2xl font-black tracking-tight text-slate-100 placeholder-slate-700 outline-none w-full"
                  />

                  {/* Meta selection inputs row */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 bg-slate-900/30 border border-slate-900 p-4 rounded-xl">
                    
                    {/* Folder Paste Selector */}
                    <div className="flex flex-col gap-1.5">
                      <span className="text-[10px] text-slate-500 font-mono uppercase tracking-wider">Assigned Pasture</span>
                      <select
                        value={editFolder}
                        onChange={(e) => setEditFolder(e.target.value)}
                        className="bg-slate-950 border border-slate-800 rounded-lg px-3 py-2 text-xs text-slate-300 outline-none focus:border-emerald-500"
                      >
                        {folders.map(f => (
                          <option key={f} value={f}>{f}</option>
                        ))}
                      </select>
                    </div>

                    {/* Herb Tags list string input */}
                    <div className="flex flex-col gap-1.5">
                      <span className="text-[10px] text-slate-500 font-mono uppercase tracking-wider">Herb Tags (comma separated)</span>
                      <input
                        type="text"
                        placeholder="e.g. delicious, climber, urgent"
                        value={editTags}
                        onChange={(e) => setEditTags(e.target.value)}
                        className="bg-slate-950 border border-slate-800 rounded-lg px-3 py-2 text-xs text-slate-300 outline-none focus:border-emerald-500 placeholder-slate-600"
                      />
                    </div>

                  </div>

                  {/* Markdown Editor Note Content */}
                  <div className="flex flex-col gap-2">
                    <span className="text-[10px] text-slate-500 font-mono uppercase tracking-wider">Note Content (supports Markdown syntax)</span>
                    <textarea
                      value={editContent}
                      onChange={(e) => setEditContent(e.target.value)}
                      placeholder="Scale the cliffs of productivity... Add lists, text, markdown style"
                      className="w-full h-80 md:h-[450px] bg-slate-950/60 border border-slate-900 focus:border-emerald-500/50 rounded-xl p-4 text-slate-200 placeholder-slate-700 text-sm leading-relaxed font-mono outline-none resize-none focus:ring-0"
                    />
                  </div>

                  {/* Quick Save Feedback Label */}
                  <div className="text-[10px] text-slate-500 font-mono flex items-center justify-between">
                    <span>💡 Custom color: <strong className="text-slate-300">{editColor.name}</strong></span>
                    <span>Autosaves immediately upon changes</span>
                  </div>

                </div>

              </div>

              {/* ========================================================
                  G.O.A.T. CO-PILOT AI TRANSLATION PANEL (RIGHT SIDEBAR)
                  ======================================================== */}
              <div className="w-full xl:w-80 border-t xl:border-t-0 xl:border-l border-slate-950 bg-slate-950/60 p-5 flex flex-col gap-4 overflow-y-auto shrink-0">
                <div className="flex items-center gap-2 border-b border-slate-900 pb-3">
                  <span className="text-xl">🐐</span>
                  <div>
                    <h4 className="text-sm font-extrabold tracking-tight text-slate-200">G.O.A.T. Co-Pilot AI</h4>
                    <p className="text-[9px] text-slate-500 font-mono uppercase tracking-wider">Note Assistant Engine</p>
                  </div>
                </div>

                {/* Translation Prompt Selector */}
                <div className="flex flex-col gap-2 bg-slate-900/50 border border-slate-900 p-3.5 rounded-xl">
                  <span className="text-[10px] text-slate-400 font-mono font-bold uppercase">Translate Mode:</span>
                  
                  <div className="grid grid-cols-2 gap-2">
                    <button
                      onClick={() => setTranslatorMode('literal')}
                      className={`p-2.5 rounded-lg border text-[10px] font-mono font-bold transition ${
                        translatorMode === 'literal'
                          ? 'bg-emerald-950/40 text-emerald-400 border-emerald-500/40'
                          : 'bg-slate-950 text-slate-400 border-slate-800'
                      }`}
                    >
                      🐐 Literal Goat
                    </button>
                    <button
                      onClick={() => setTranslatorMode('coach')}
                      className={`p-2.5 rounded-lg border text-[10px] font-mono font-bold transition ${
                        translatorMode === 'coach'
                          ? 'bg-emerald-950/40 text-emerald-400 border-emerald-500/40'
                          : 'bg-slate-950 text-slate-400 border-slate-800'
                      }`}
                    >
                      🥇 G.O.A.T Coach
                    </button>
                  </div>

                  <p className="text-[10px] text-slate-500 leading-relaxed mt-2 italic">
                    {translatorMode === 'literal' 
                      ? "Converts normal human thoughts into 'baaas', 'grass munching' sounds, and mountain wisdom."
                      : "The ultimate productivity coach analyzes your notes to inject hyper-focused Greatest of All Time directives."}
                  </p>

                  <button
                    onClick={handleGoatTranslation}
                    disabled={isTranslating}
                    className="w-full mt-2 text-xs font-bold font-mono py-2.5 bg-emerald-500 text-slate-950 rounded-lg hover:bg-emerald-400 transition flex items-center justify-center gap-1.5"
                  >
                    {isTranslating ? (
                      <>
                        <span className="animate-spin inline-block mr-1">🌾</span>
                        <span>Munching Note...</span>
                      </>
                    ) : (
                      <>
                        <span>🚀</span>
                        <span>Goat-ify This Note</span>
                      </>
                    )}
                  </button>
                </div>

                {/* Translation Output Display Card */}
                {translatedText && (
                  <div className="bg-slate-900/30 border border-emerald-500/20 rounded-xl p-4 flex flex-col gap-3 animate-fadeIn">
                    <div className="flex justify-between items-center text-[10px] text-slate-400 font-mono border-b border-slate-900 pb-1.5">
                      <span>📢 Output Voice Profile:</span>
                      <span className="text-emerald-400 font-bold uppercase">{translatorMode} Goat</span>
                    </div>

                    {/* Pre-formatted translation result */}
                    <div className="text-xs text-slate-300 leading-relaxed font-mono whitespace-pre-wrap max-h-64 overflow-y-auto bg-slate-950 p-3 rounded-lg border border-slate-900">
                      {translatedText}
                    </div>

                    <button
                      onClick={() => {
                        // Append translate logic to note draft
                        setEditContent(editContent + "\n\n---\n" + translatedText);
                        triggerNotification("Appended translation to note content.");
                      }}
                      className="text-[10px] font-bold font-mono text-emerald-400 hover:text-emerald-300 hover:underline text-left mt-1"
                    >
                      📎 Append results directly into Draft Note
                    </button>
                  </div>
                )}
              </div>

            </div>
          ) : (
            <div className="flex-grow flex flex-col items-center justify-center text-center p-12 gap-3">
              <span className="text-6xl animate-bounce">🧗</span>
              <h3 className="text-xl font-extrabold text-slate-100">Empty Meadow Pasture</h3>
              <p className="text-xs text-slate-400 font-mono max-w-sm leading-relaxed">
                You have no active notes currently selected. Click on the button below or pick an existing mountain log from the sidebar.
              </p>
              <button
                onClick={handleCreateNote}
                className="mt-4 px-5 py-2.5 bg-emerald-500 text-slate-950 font-bold text-xs rounded-lg shadow-lg tracking-wide hover:bg-emerald-400 transition"
              >
                + Create First Climbing Log
              </button>
            </div>
          )}
        </section>

      </div>

      {/* FOOTER STATS BAR */}
      <footer className="bg-slate-950 border-t border-slate-900 py-3.5 px-6 text-center text-[10px] text-slate-500 font-mono flex flex-col sm:flex-row justify-between items-center gap-4">
        <div>
          🏔️ Crafted with uncompromised mountain resilience for premium thinkers. Build daily, graze safely.
        </div>
        <div className="flex gap-4">
          <span className="text-emerald-400">Pasture: Grazed & Secure</span>
          <span>Engine: GoatOS v1.4</span>
        </div>
      </footer>

    </div>
  );
}

```
