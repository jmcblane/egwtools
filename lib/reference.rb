#!/usr/bin/ruby

$reference_works = {
    "Children Stories" => 1320,
    "Historical References" => 20,
    "Reference Works" => 13,
    "Research Documents" => 12,
    "Scripture Index" => 930,
    "Study Guides" => 1327,
    "Topical Index" => 931
}

$pioneer_dirs = {
    "Andrews, John Nevins" => 132,
    "Bates, Joseph" => 136,
    "Bliss, Sylvester" => 137,
    "Bourdeau, Daniel T." => 138,
    "Butler, George Ide" => 139,
    "Cornell, Merritt E." => 141,
    "Cottrell, Roswell Fenner" => 142,
    "Crosier, Owen Russell Loomis" => 143,
    "Daniells, Arthur Grosvenor" => 144,
    "Fitch, Charles" => 146,
    "Foy, William Ellis" => 147,
    "Hale, Apollos" => 148,
    "Haskell, Stephen Nelson" => 149,
    "Jones, Alonzo Trevier" => 150,
    "Litch, Josiah" => 152,
    "Loughborough, John Norton" => 153,
    "Magan, Percy Tilson" => 154,
    "Miller, William" => 155,
    "Paulson, David" => 1049,
    "Preble, Thomas Motherwell" => 156,
    "Prescott, William Warren" => 157,
    "Smith, Annie Rebekah" => 158,
    "Smith, Rebekah" => 159,
    "Smith, Uriah" => 160,
    "Stephenson, James M." => 162,
    "Storrs, George" => 163,
    "Waggoner, Ellet Joseph" => 164,
    "Waggoner, Joseph Harvey" => 165,
    "Ward, Henry Dana" => 166,
    "White, James" => 167,
    "Whiting, Nathaniel N." => 169
}

$periodicals = {
    "The Advent Mirror" => 175,
    "Advent Review & Sabbath Herald" => 180,
    "The Advent Review" => 179,
    "The Advent Testimony" => 177,
    "The Daily Argus Extracts" => 173,
    "GC Bulletins" => 182,
    "GC Daily Bulletins" => 181,
    "The Jubilee Standard" => 176,
    "The Present Truth" => 178,
    "Signs of the Times [Himes]" => 174,
    "The True Midnight Cry" => 172
}

$books_bible = ['Genesis', 'Exodus', 'Psalm', 'Proverbs', 'Leviticus', 'Numbers', 'Deuteronomy', 'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel', '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles', 'Ezra', 'Nehemiah', 'Esther', 'Job', 'Ecclesiastes', 'Song of Solomon', 'Isaiah', 'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel', 'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah', 'Malachi', 'Matthew', 'Mark', 'Luke', 'John', 'Acts', 'Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians', '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews', 'James', '1 Peter', '2 Peter', '1 John', '2 John', '3 John', 'Jude', 'Revelation' ]
