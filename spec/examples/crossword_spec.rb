require "byebug"

ALPHABET = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z .].freeze
WORDS = %w[
  a
  ability
  able
  about
  above
  accept
  according
  account
  across
  act
  action
  activity
  actually
  add
  address
  administration
  admit
  adult
  affect
  after
  again
  against
  age
  agency
  agent
  ago
  agree
  agreement
  ahead
  air
  all
  allow
  almost
  alone
  along
  already
  also
  although
  always
  american
  among
  amount
  analysis
  and
  animal
  another
  answer
  any
  anyone
  anything
  appear
  apply
  approach
  area
  argue
  arm
  around
  arrive
  art
  article
  artist
  as
  ask
  assume
  at
  attack
  attention
  attorney
  audience
  author
  authority
  available
  avoid
  away
  baby
  back
  bad
  bag
  ball
  bank
  bar
  base
  be
  beat
  beautiful
  because
  become
  bed
  before
  begin
  behavior
  behind
  believe
  benefit
  best
  better
  between
  beyond
  big
  bill
  billion
  bit
  black
  blood
  blue
  board
  body
  book
  born
  both
  box
  boy
  break
  bring
  brother
  budget
  build
  building
  business
  but
  buy
  by
  call
  camera
  campaign
  can
  cancer
  candidate
  capital
  car
  card
  care
  career
  carry
  case
  catch
  cause
  cell
  center
  central
  century
  certain
  certainly
  chair
  challenge
  chance
  change
  character
  charge
  check
  child
  choice
  choose
  church
  citizen
  city
  civil
  claim
  class
  clear
  clearly
  close
  coach
  cold
  collection
  college
  color
  come
  commercial
  common
  community
  company
  compare
  computer
  concern
  condition
  conference
  congress
  consider
  consumer
  contain
  continue
  control
  cost
  could
  country
  couple
  course
  court
  cover
  create
  crime
  cultural
  culture
  cup
  current
  customer
  cut
  dark
  data
  daughter
  day
  dead
  deal
  death
  debate
  decade
  decide
  decision
  deep
  defense
  degree
  democrat
  democratic
  describe
  design
  despite
  detail
  determine
  develop
  development
  die
  difference
  different
  difficult
  dinner
  direction
  director
  discover
  discuss
  discussion
  disease
  do
  doctor
  dog
  door
  down
  draw
  dream
  drive
  drop
  drug
  during
  each
  early
  east
  easy
  eat
  economic
  economy
  edge
  education
  effect
  effort
  eight
  either
  election
  else
  employee
  end
  energy
  enjoy
  enough
  enter
  entire
  environment
  environmental
  especially
  establish
  even
  evening
  event
  ever
  every
  everybody
  everyone
  everything
  evidence
  exactly
  example
  executive
  exist
  expect
  experience
  expert
  explain
  eye
  face
  fact
  factor
  fail
  fall
  family
  far
  fast
  father
  fear
  federal
  feel
  feeling
  few
  field
  fight
  figure
  fill
  film
  final
  finally
  financial
  find
  fine
  finger
  finish
  fire
  firm
  first
  fish
  five
  floor
  fly
  focus
  follow
  food
  foot
  for
  force
  foreign
  forget
  form
  former
  forward
  four
  free
  friend
  from
  front
  full
  fund
  future
  game
  garden
  gas
  general
  generation
  get
  girl
  give
  glass
  go
  goal
  good
  government
  great
  green
  ground
  group
  grow
  growth
  guess
  gun
  guy
  hair
  half
  hand
  hang
  happen
  happy
  hard
  have
  he
  head
  health
  hear
  heart
  heat
  heavy
  help
  her
  here
  herself
  high
  him
  himself
  his
  history
  hit
  hold
  home
  hope
  hospital
  hot
  hotel
  hour
  house
  how
  however
  huge
  human
  hundred
  husband
  idea
  identify
  if
  image
  imagine
  impact
  important
  improve
  in
  include
  including
  increase
  indeed
  indicate
  individual
  industry
  information
  inside
  instead
  institution
  interest
  interesting
  international
  interview
  into
  investment
  involve
  issue
  it
  item
  its
  itself
  job
  join
  just
  keep
  key
  kid
  kill
  kind
  kitchen
  know
  knowledge
  land
  language
  large
  last
  late
  later
  laugh
  law
  lawyer
  lay
  lead
  leader
  learn
  least
  leave
  left
  leg
  legal
  less
  let
  letter
  level
  lie
  life
  light
  like
  likely
  line
  list
  listen
  little
  live
  local
  long
  look
  lose
  loss
  lot
  love
  low
  machine
  magazine
  main
  maintain
  major
  majority
  make
  man
  manage
  management
  manager
  many
  market
  marriage
  material
  matter
  may
  maybe
  me
  mean
  measure
  media
  medical
  meet
  meeting
  member
  memory
  mention
  message
  method
  middle
  might
  military
  million
  mind
  minute
  miss
  mission
  model
  modern
  moment
  money
  month
  more
  morning
  most
  mother
  mouth
  move
  movement
  movie
  much
  music
  must
  my
  myself
  name
  nation
  national
  natural
  nature
  near
  nearly
  necessary
  need
  network
  never
  new
  news
  newspaper
  next
  nice
  night
  no
  none
  nor
  north
  not
  note
  nothing
  notice
  now
  number
  occur
  of
  off
  offer
  office
  officer
  official
  often
  oh
  oil
  ok
  old
  on
  once
  one
  only
  onto
  open
  operation
  opportunity
  option
  or
  order
  organization
  other
  others
  our
  out
  outside
  over
  own
  owner
  page
  pain
  painting
  paper
  parent
  part
  participant
  particular
  particularly
  partner
  party
  pass
  past
  patient
  pattern
  pay
  peace
  people
  per
  perform
  performance
  perhaps
  period
  person
  personal
  phone
  physical
  pick
  picture
  piece
  place
  plan
  plant
  play
  player
  point
  police
  policy
  political
  politics
  poor
  popular
  population
  position
  positive
  possible
  power
  practice
  prepare
  present
  president
  pressure
  pretty
  prevent
  price
  private
  probably
  problem
  process
  produce
  product
  production
  professional
  professor
  program
  project
  property
  protect
  prove
  provide
  public
  pull
  purpose
  push
  put
  quality
  question
  quickly
  quite
  race
  radio
  raise
  range
  rate
  rather
  reach
  read
  ready
  real
  reality
  realize
  really
  reason
  receive
  recent
  recently
  recognize
  record
  red
  reduce
  reflect
  region
  relate
  relationship
  religious
  remain
  remember
  remove
  report
  represent
  republican
  require
  research
  resource
  respond
  response
  responsibility
  rest
  result
  return
  reveal
  rich
  right
  rise
  risk
  road
  rock
  role
  room
  rule
  run
  safe
  same
  save
  say
  scene
  school
  science
  scientist
  score
  sea
  season
  seat
  second
  section
  security
  see
  seek
  seem
  sell
  send
  senior
  sense
  series
  serious
  serve
  service
  set
  seven
  several
  sex
  sexual
  shake
  share
  she
  shoot
  short
  shot
  should
  shoulder
  show
  side
  sign
  significant
  similar
  simple
  simply
  since
  sing
  single
  sister
  sit
  site
  situation
  six
  size
  skill
  skin
  small
  smile
  so
  social
  society
  soldier
  some
  somebody
  someone
  something
  sometimes
  son
  song
  soon
  sort
  sound
  source
  south
  southern
  space
  speak
  special
  specific
  speech
  spend
  sport
  spring
  staff
  stage
  stand
  standard
  star
  start
  state
  statement
  station
  stay
  step
  still
  stock
  stop
  store
  story
  strategy
  street
  strong
  structure
  student
  study
  stuff
  style
  subject
  success
  successful
  such
  suddenly
  suffer
  suggest
  summer
  support
  sure
  surface
  system
  table
  take
  talk
  task
  tax
  teach
  teacher
  team
  technology
  television
  tell
  ten
  tend
  term
  test
  than
  thank
  that
  the
  their
  them
  themselves
  then
  theory
  there
  these
  they
  thing
  think
  third
  this
  those
  though
  thought
  thousand
  threat
  three
  through
  throughout
  throw
  thus
  time
  to
  today
  together
  tonight
  too
  top
  total
  tough
  toward
  town
  trade
  traditional
  training
  travel
  treat
  treatment
  tree
  trial
  trip
  trouble
  true
  truth
  try
  turn
  tv
  two
  type
  under
  understand
  unit
  until
  up
  upon
  us
  use
  usually
  value
  various
  very
  victim
  view
  violence
  visit
  voice
  vote
  wait
  walk
  wall
  want
  war
  watch
  water
  way
  we
  weapon
  wear
  week
  weight
  well
  west
  western
  what
  whatever
  when
  where
  whether
  which
  while
  white
  who
  whole
  whom
  whose
  why
  wide
  wife
  will
  win
  wind
  window
  wish
  with
  within
  without
  woman
  wonder
  word
  work
  worker
  world
  worry
  would
  write
  writer
  wrong
  yard
  yeah
  year
  yes
  yet
  you
  young
  your
  yourself
]

W = 6 # cols
H = 6 # rows

@matrix = []

def build_zeroes_array(size, one_index)
  (0..size - 1).map do |i| i == one_index ? 1 : 0 end
end

def build_ones_array(size, zero_index)
  (0..size - 1).map do |i| i == zero_index ? 0 : 1 end
end

matrix_rows = []

# adds the blanks

# vertical words
# adds one letter words
# words.each do |word|
#   (0..H-1).each do |row|
#     (0..W-1).each do |col|
#       matrix_row = []
#
#       # Horizontal "word"
#       word_index = (row * W + col) * alphabet.size + alphabet.index(letter)
#       horizontal_row = build_zeroes_array(W * H * alphabet.size, word_index)
#       vertical_row = build_zeroes_array(W * H * alphabet.size, -1)
#
#       word_index = (row * W + col) * alphabet.size
#       alphabet.each do |abc|
#         next if letter == abc
#
#         vertical_row[word_index + alphabet.index(abc)] = 1
#       end
#
#       matrix_row = horizontal_row + vertical_row
#       matrix << matrix_row
#
#       matrix_row = vertical_row + horizontal_row
#       matrix << matrix_row
#     end
#   end
# end

#

def add_horizontal_word(word, row, col, word_index, real: true)
  puts "Adding #{word} to #{row}, #{col}"
  matrix_row = Array.new(2 * W * H * ALPHABET.size, 0)

  offset = W * H * ALPHABET.size
  offset_words = 2 * W * H * ALPHABET.size

  word.split("").each_with_index do |letter, idx|
    break if col + idx >= W

    index = (row * W + col + idx) * ALPHABET.size

    # horizontal part
    matrix_row[index + ALPHABET.index(letter)] = 1

    # vertical part
    ALPHABET.each do |alphabet_letter|
      if alphabet_letter != letter
        matrix_row[offset + index + ALPHABET.index(alphabet_letter)] = 1
      end
    end

    add_vertical_word(letter, row, col + idx, word_index, real: false) if real
  end

  if word != "." && col + word.size < W
    # add a X at the end of the word
    index = (row * W + col + word.size) * ALPHABET.size

    # horizontal part
    matrix_row[index + ALPHABET.index(".")] = 1

    # vertical part
    ALPHABET.each do |alphabet_letter|
      if alphabet_letter != "."
        matrix_row[offset + index + ALPHABET.index(alphabet_letter)] = 1
      end
    end
  end

  @matrix_row_to_word[matrix_row] = Word.new(word, row, col, true) if word.size > 1
  @matrix << matrix_row
end

def add_vertical_word(word, row, col, word_index, real: true)
  puts "Adding #{word} to #{row}, #{col}"

  matrix_row = Array.new(2 * W * H * ALPHABET.size, 0)

  offset = W * H * ALPHABET.size
  offset_words = 2 * W * H * ALPHABET.size

  word.split("").each_with_index do |letter, idx|
    break if row + idx >= H

    index = ((row + idx) * W + col) * ALPHABET.size

    # horizontal part
    ALPHABET.each do |alphabet_letter|
      if alphabet_letter != letter
        matrix_row[index + ALPHABET.index(alphabet_letter)] = 1
      end
    end

    # vertical part
    matrix_row[offset + index + ALPHABET.index(letter)] = 1

    add_horizontal_word(letter, row + idx, col, word_index, real: false) if real
  end

  if word != "." && row + word.size < H
    # add a X at the end of the word
    index = ((row + word.size) * W + col) * ALPHABET.size

    # vertical part
    matrix_row[offset + index + ALPHABET.index(".")] = 1

    # horizontal part
    ALPHABET.each do |alphabet_letter|
      if alphabet_letter != "."
        matrix_row[index + ALPHABET.index(alphabet_letter)] = 1
      end
    end
  end

  @matrix_row_to_word[matrix_row] = Word.new(word, row, col, false) if word.size > 1
  @matrix << matrix_row
end

# generate masks for word count
# def generate_masks(row, col)
#   (0..WORDS.size-1).to_a.combination(2).each do |a, b|
#     matrix_row = Array.new(2 * W * H * ALPHABET.size + WORDS.size * W * H, 0)
#     offset_words = 2 * W * H * ALPHABET.size
#
#     (0..WORDS.size-1).each do |i|
#       matrix_row[offset_words + (row * W + col) + i] = 1 if i != a && i != b
#     end
#
#     @matrix << matrix_row
#   end
# end

def add_black_square(row, col)
  matrix_row = Array.new(2 * W * H * ALPHABET.size)

  offset = W * H * ALPHABET.size
  # horizontal
  index = (row * W + col) * ALPHABET.size
  (0..ALPHABET.size-1).each do |i|
    matrix_row[index + i] = 1

    matrix_row[offset + index + i] = 1
  end

  # matrix_row += Array.new(WORDS.size * W * H, 0)
  # offset = 2 * W * H * ALPHABET.size
  # (0..WORDS.size-1).each do |word_index|
  #   matrix_row[offset + (row * W + col) * WORDS.size + word_index] = 1
  # end

  matrix_row
end

Word = Struct.new(:word, :row, :col, :horizontal)

@matrix_row_to_word = {}

WORDS.each do |word|
  word_index = WORDS.index(word)

  # represent the word in the row
  (0..H-1).each do |row|
    (0..W-1).each do |col|
      if word.size + col <= W
        add_horizontal_word(word, row, col, word_index)
      end

      if word.size + row <= H
        add_vertical_word(word, row, col, word_index)
      end

      # generate_masks(row, col)
    end
  end
end

# add_vertical_word("ac", 0, 0, 1)


# (0..WORDS.size-2).each do |w1|
#   (w1..WORDS.size-1).each do |w2|
#     matrix_row = Array.new(2 * W * H * ALPHABET.size + WORDS.size * W * H, 0)
#     offset = 2 * W * H * ALPHABET.size
#
#     (0..H-1).each do |row|
#       (0..W-1).each do |col|
#         (0..WORDS.size-1).each do |w|
#           matrix_row[offset + WORDS.size * (row * W + col) + w] = 1 if w != w1 && w != w2
#         end
#
#         @matrix << matrix_row
#       end
#     end
#   end
# end
#
(0..H-1).each do |row|
  (0..W-1).each do |col|

    # Add a black square
    # matrix_row = add_black_square(row, col)
    # @matrix_row_to_word[matrix_row] = Word.new("X", row, col, true)
    # @matrix << matrix_row


    add_horizontal_word(".", row, col, WORDS.index("."), real: false)
    add_vertical_word(".", row, col, WORDS.index("."), real: false)

  end
end


#
# @matrix.each do |r|
#   word = b X X@matrix_row_to_word[r]
#   w = word ? "#{word.word} (#{word.row}, #{word.col})" : "N/A"
#   puts r[16..-1].join("") + " -> " + "#{w}"
# end

solutions = ExactCover::CoverSolver.new(@matrix.uniq.shuffle).call


def format_solution(solution)
  grid = Array.new(H)
  (0..H-1).each do |row|
    grid[row] = Array.new(W, ".")
  end

  solution.each do |matrix_row|
    word = @matrix_row_to_word[matrix_row]
    # puts "word: #{word}"
    next unless word

    word.word.split("").each_with_index do |letter, idx|
      if word.horizontal
        col_index = word.col + idx
        grid[word.row][col_index] = letter
      else
        row_index = word.row + idx
        grid[row_index][word.col] = letter
      end
    end
  end

  (0..H-1).each do |row|
    row_str = ""
    (0..W-1).each do |col|
      row_str << grid[row][col] + " "
    end
    puts row_str
  end
end



solutions.each do |sol|
  format_solution(sol)
  puts "____"
end
