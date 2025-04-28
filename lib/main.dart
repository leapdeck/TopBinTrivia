import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'data/countries.dart';

final Map<String, String> countryMap = {
  '🇪🇨 Ecuador': 'Ecuador',
  '🇸🇳 Senegal': 'Senegal',
  '🇲🇽 Mexico': 'Mexico',
  '🇫🇷 France': 'France',
  '🇵🇪 Peru' : 'Peru',
  '🇪🇸 Spain': 'Spain',
  '🇧🇷 Brazil': 'Brazil',
  '🇻🇪 Venezuela': 'Venezuela',
  '🇩🇰 Denmark': 'Denmark',
  '🇯🇵 Japan': 'Japan',
  '🇫🇮 Finland': 'Finland',
  '🇨🇷 Costa Rica': 'Costa Rica',
  '🇦🇷 Argentina': 'Argentina',
  '🇨🇦 Canada': 'Canada',
  '🇰🇷 South Korea': 'South Korea',
  '🇺🇸 U.S.': 'U.S.',
  '🇸🇪 Sweden': 'Sweden',
  '🇲🇦 Morocco': 'Morocco',
  '🇷🇸 Serbia': 'Serbia',
  '🇨🇭 Switzerland': 'Switzerland',
  '🇨🇲 Cameroon': 'Cameroon',
  '🇵🇹 Portugal': 'Portugal',
  '🇬🇭 Ghana': 'Ghana',
  '🇺🇾 Uruguay': 'Uruguay',
  '🇭🇷 Croatia': 'Croatia',
  '🇧🇪 Belgium': 'Belgium',
  '🇨🇱 Chile': 'Chile',
  '🇨🇴 Colombia': 'Colombia',
//  '🇵🇱 Poland': 'Poland',
  '🇮🇹 Italy': 'Italy',
  '🇳🇬 Nigeria': 'Nigeria',
  '🇭🇳 Honduras': 'Honduras',
  '🇹🇬 Togo': 'Togo',
  '🇧🇫 Burkina Faso': 'Burkina Faso',
  '🇹🇳 Tunisia': 'Tunisia',
  '🇧🇴 Bolivia': 'Bolivia',
  '🇹🇭 Thailand': 'Thailand',
'🇵🇾 Paraguay' : 'Paraguay',
'🇬🇱 Greenland' : 'Greenland',
'🇱🇰 Jamaica' : 'Jamaica',
'🇱🇰 Sri Lanka' : 'Sri Lanka',
'🇹🇹 Trinidad' : 'Trinidad',
};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class QuizQuestion {
  final String question;
  final String answer;
  final String wrongoption1;
  final String wrongoption2;
  final String wrongoption3;
  final String wrongoption4;

  QuizQuestion({
    required this.question,
    required this.answer,
    required this.wrongoption1,
    required this.wrongoption2,
    required this.wrongoption3,
    required this.wrongoption4,
  });

  List<String> get wrongOptions => [wrongoption1, wrongoption2, wrongoption3, wrongoption4];

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question']?.toString() ?? 'No question available',
      answer: json['answer']?.toString() ?? 'No answer available',
      wrongoption1: json['wrongoption1']?.toString() ?? 'Option 1',
      wrongoption2: json['wrongoption2']?.toString() ?? 'Option 2',
      wrongoption3: json['wrongoption3']?.toString() ?? 'Option 3',
      wrongoption4: json['wrongoption4']?.toString() ?? 'Option 4',
    );
  }
}

class Activity2Screen extends StatefulWidget {
  final List<String> selectedCountries;
  const Activity2Screen({super.key, required this.selectedCountries});

  @override
  State<Activity2Screen> createState() => _Activity2ScreenState();
}

class _Activity2ScreenState extends State<Activity2Screen> {
  late QuizQuestion currentQuestion;
  late List<String> options;
  String? selectedAnswer;
  String? feedback;
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    final country = widget.selectedCountries.first;
    if (quizData.containsKey(country)) {
      currentQuestion = QuizQuestion.fromJson(quizData[country]![2]);
      options = [
        currentQuestion.answer,
        currentQuestion.wrongoption1,
        currentQuestion.wrongoption2,
        currentQuestion.wrongoption3,
      ];
      final random = math.Random(2);
      options.shuffle(random);
    }
  }

  void _handleAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      feedback = answer == currentQuestion.answer ? "Correct" : "Good Try, Incorrect Though";
      showFeedback = true;
    });

    ScoreTracker().addAnswer(answer == currentQuestion.answer);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Activity3Screen(selectedCountries: widget.selectedCountries),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ...options.map((option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: selectedAnswer == null
                    ? () => _handleAnswer(option)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: selectedAnswer == option
                      ? (option == currentQuestion.answer
                          ? Colors.green
                          : Colors.red)
                      : null,
                ),
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )),
            const Spacer(),
            if (showFeedback)
              Text(
                feedback!,
                style: TextStyle(
                  fontSize: 24 * 0.7,
                  fontWeight: FontWeight.bold,
                  color: feedback == "Correct" ? Colors.green : Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Activity3Screen extends StatefulWidget {
  final List<String> selectedCountries;
  const Activity3Screen({super.key, required this.selectedCountries});

  @override
  State<Activity3Screen> createState() => _Activity3ScreenState();
}

class _Activity3ScreenState extends State<Activity3Screen> {
  late QuizQuestion currentQuestion;
  late List<String> options;
  String? selectedAnswer;
  String? feedback;
  bool showFeedback = false;
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> allQuestions = [];
  static const int totalQuestions = 10;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  void _initializeQuestions() {
    for (String country in widget.selectedCountries) {
      if (quizData.containsKey(country)) {
        allQuestions.addAll(quizData[country]!);
      }
    }

    allQuestions.shuffle();
    allQuestions = allQuestions.take(totalQuestions).toList();
    _loadQuestion();
  }

  void _loadQuestion() {
    if (currentQuestionIndex >= allQuestions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Activity4Screen(
            selectedCountries: widget.selectedCountries,
            totalQuestions: totalQuestions,
          ),
        ),
      );
      return;
    }

    currentQuestion = QuizQuestion.fromJson(allQuestions[currentQuestionIndex]);
    options = [
      currentQuestion.answer,
      currentQuestion.wrongoption1,
      currentQuestion.wrongoption2,
      currentQuestion.wrongoption3,
    ];
    final random = math.Random(currentQuestionIndex);
    options.shuffle(random);
  }

  void _handleAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      feedback = answer == currentQuestion.answer ? "Correct" : "Good Try, Incorrect Though";
      showFeedback = true;
    });

    ScoreTracker().addAnswer(answer == currentQuestion.answer);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentQuestionIndex++;
          _loadQuestion();
          selectedAnswer = null;
          showFeedback = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}/$totalQuestions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ...options.map((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: selectedAnswer == null
                        ? () => _handleAnswer(option)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: selectedAnswer == option
                          ? (option == currentQuestion.answer
                              ? Colors.green
                              : Colors.red)
                          : null,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                )),
            const Spacer(),
            if (showFeedback)
              Text(
                feedback!,
                style: TextStyle(
                  fontSize: 24 * 0.8,
                  fontWeight: FontWeight.bold,
                  color: feedback == "Correct" ? Colors.green : Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Activity4Screen extends StatelessWidget {
  final List<String> selectedCountries;
  final int totalQuestions;

  const Activity4Screen({
    Key? key, 
    required this.selectedCountries, 
    required this.totalQuestions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreTracker = ScoreTracker();
    final correctAnswers = scoreTracker.getCorrectAnswers();
    final percentage = scoreTracker.getPercentage();
    final wrongPercentage = 100 - percentage;

    // Convert country names back to emoji format for selection
    final Set<String> selectedCountriesWithEmoji = selectedCountries
        .map((country) => countryMap.entries
            .firstWhere((entry) => entry.value == country)
            .key)
        .toSet()
        .cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Summary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Combo Completion!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: percentage,
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                    ),
                    PieChartSectionData(
                      value: wrongPercentage,
                      title: '${wrongPercentage.toStringAsFixed(0)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      color: Colors.orange.shade200,
                    ),
                  ],
                  sectionsSpace: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $correctAnswers/$totalQuestions',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Win Percentage : ${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Reset score and restart quiz with same countries
                      ScoreTracker().reset();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Activity3Screen(
                            selectedCountries: selectedCountries,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text('Play Selection Again'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountrySelectionScreen(
                          initialSelectedCountries: selectedCountriesWithEmoji,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text('Main Country Menu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Activity5Screen extends StatefulWidget {
  final List<String> selectedCountries;
  const Activity5Screen({super.key, required this.selectedCountries});

  @override
  State<Activity5Screen> createState() => _Activity5ScreenState();
}

class _Activity5ScreenState extends State<Activity5Screen> {
  late QuizQuestion currentQuestion;
  late List<String> options;
  String? selectedAnswer;
  String? feedback;
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    final country = widget.selectedCountries.first;
    if (quizData.containsKey(country)) {
      currentQuestion = QuizQuestion.fromJson(quizData[country]![5]);
      options = [
        currentQuestion.answer,
        currentQuestion.wrongoption1,
        currentQuestion.wrongoption2,
        currentQuestion.wrongoption3,
      ];
      final random = math.Random(5);
      options.shuffle(random);
    }
  }

  void _handleAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      feedback = answer == currentQuestion.answer ? "Correct" : "Good Try, Incorrect Though";
      showFeedback = true;
    });

    ScoreTracker().addAnswer(answer == currentQuestion.answer);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              scoreTracker: ScoreTracker(),
              totalQuestions: 5,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 5'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ...options.map((option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: selectedAnswer == null
                    ? () => _handleAnswer(option)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: selectedAnswer == option
                      ? (option == currentQuestion.answer
                          ? Colors.green
                          : Colors.red)
                      : null,
                ),
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )),
            const Spacer(),
            if (showFeedback)
              Text(
                feedback!,
                style: TextStyle(
                  fontSize: 24 * 0.7,
                  fontWeight: FontWeight.bold,
                  color: feedback == "Correct" ? Colors.green : Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Activity1Screen extends StatelessWidget {
  final List<String> selectedCountries;
  const Activity1Screen({super.key, required this.selectedCountries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity 1 - ${selectedCountries.first}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Quiz!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Activity3Screen(selectedCountries: selectedCountries),
                  ),
                );
              },
              child: const Text('Start Trivia'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Bin Trivia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to CountrySelectionScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CountrySelectionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Top Bin Trivia',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.white,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Expanded(
              child: Center(
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.9,
                  // height: MediaQuery.of(context).size.width * 0.9
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/splash_ball.png'),
                    //  fit: BoxFit.contain,
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreTracker {
  static final ScoreTracker _instance = ScoreTracker._internal();
  factory ScoreTracker() => _instance;

  final List<bool> answers = [];

  ScoreTracker._internal();

  void addAnswer(bool isCorrect) {
    answers.add(isCorrect);
  }

  int getCorrectAnswers() {
    return answers.where((a) => a).length;
  }

    double getPercentage() {
    if (answers.isEmpty) return 0;
    final correctCount = answers.where((answer) => answer).length;
    return (correctCount / answers.length) * 100;
  }

    int getTotalAnswers() {
    return answers.length;
  }

  void reset() {
    answers.clear();
  }
}

class ResultsScreen extends StatelessWidget {
  final ScoreTracker scoreTracker;
  final int totalQuestions;

  const ResultsScreen({
    super.key,
    required this.scoreTracker,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = scoreTracker.getPercentage();
    final correctAnswers = scoreTracker.getCorrectAnswers();
    final totalAnswers = scoreTracker.getTotalAnswers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your Score',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 70 ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$correctAnswers out of $totalAnswers correct',
                style: const TextStyle(
                  fontSize: 24,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CountrySelectionScreen(),
                    ),
                  );
                },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountrySelectionScreen extends StatefulWidget {
  final Set<String>? initialSelectedCountries;
  const CountrySelectionScreen({
    super.key,
    this.initialSelectedCountries,
  });

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  late Set<String> selectedCountries;

  @override
  void initState() {
    super.initState();
    selectedCountries = widget.initialSelectedCountries ?? {};
  }

  void _startQuiz() {
    if (selectedCountries.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 2 countries'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Reset score before starting
    ScoreTracker().reset();

    // Convert selected countries to list of country names
    List<String> selectedCountryNames = selectedCountries
        .map((country) => countryMap[country]!)
        .where((name) => name != null)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Activity3Screen(
          selectedCountries: selectedCountryNames,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Countries'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(
                  color: Colors.blue.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select 2 to 8 countries:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                if (selectedCountries.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: _startQuiz,
                    icon: const Icon(Icons.play_arrow, size: 20 * 0.8),
                    label: Text(
                      'Start Trivia(${selectedCountries.length}/8)',
                      style: const TextStyle(fontSize: 16 * 0.8),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16 * 0.8, vertical: 8 * 0.8),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: countryMap.length,
              itemBuilder: (context, index) {
                final country = countryMap.keys.elementAt(index);
                final isSelected = selectedCountries.contains(country);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        selectedCountries.remove(country);
                      } else if (selectedCountries.length < 8) {
                        selectedCountries.add(country);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maximum 8 countries allowed'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      country,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
