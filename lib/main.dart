

import 'dart:math';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:particle_background/simple_animations_package.dart';
import 'package:flutter_html/flutter_html.dart';

void main() => runApp(const DGApp());

class DGApp extends StatelessWidget {
  const DGApp({Key? key}) : super(key: key);

      
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // body: ParticleBackgroundPage(),
      body: Html(data: '''
      <h1>foo-2</h1>
<div style="position: relative; padding-top: 99.36238044633369%;">
<iframe src="https://iframe.videodelivery.net/74b65eef7194e394d4cc905997679ff5?autoplay=true&poster=https%3A%2F%2Fvideodelivery.net%2F74b65eef7194e394d4cc905997679ff5%2Fthumbnails%2Fthumbnail.jpg%3Ftime%3D%26height%3D600" style="border: none; position: absolute; top: 0; left: 0; height: 100%; width: 100%;" allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;" allowfullscreen="true">
</iframe></div>
    <h2>ff</h2>
'''      )
      ),

    );
  }
}

class ParticleBackgroundPage extends StatelessWidget {
  const ParticleBackgroundPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     var htmlData = '''
<div style="position: relative; padding-top: 74.8936170212766%;">
<iframe src="https://iframe.videodelivery.net/a146b36241effd7e32ee00306363ca60?autoplay=true&poster=https%3A%2F%2Fvideodelivery.net%2Fa146b36241effd7e32ee00306363ca60%2Fthumbnails%2Fthumbnail.jpg%3Ftime%3D%26height%3D600" style="border: none; position: absolute; top: 0; left: 0; height: 100%; width: 100%;" allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;" allowfullscreen="true"></iframe></div>
      ''';
    return Stack(
      children:  [
        Positioned.fill(child: AnimatedBackground()),
        Positioned.fill(child: Particles(77)),
        // Positioned.fill(child: CenteredText()),
       Positioned.fill(child: Html(data: '''
<iframe src="https://iframe.videodelivery.net/a146b36241effd7e32ee00306363ca60?autoplay=true"''')),
        Positioned.fill(child: CenteredText()),

      ],
    );
  }
}

class Particles extends StatefulWidget {
  final int numberOfParticles;

  const Particles(this.numberOfParticles, {key}) : super(key: key);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      startTime: const Duration(seconds: 30),
      onTick: _simulateParticles,
      builder: (context, time) {
        return CustomPaint(
          painter: ParticlePainter(particles, time),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    for (var particle in particles) {
      particle.maintainRestart(time);
    }
  }
}

class ParticleModel {
  late Animatable tween;
  late double size;
  late AnimationProgress animationProgress;
  Random random;

  ParticleModel(this.random) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 3000 + random.nextInt(6000));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
    ]);
    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 0.2 + random.nextDouble() * 0.4;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(50);

    for (var particle in particles) {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final position =
          Offset(animation["x"] * size.width, animation["y"] * size.height);
      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(
          const Duration(seconds: 133),
          ColorTween(
              begin: const Color(0xff8a113a), end: Colors.lightBlue.shade900)),
      Track("color2").add(const Duration(seconds: 33),
          ColorTween(begin: const Color(0xff440216), end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, dynamic animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}



class CenteredText extends StatelessWidget {
  const CenteredText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Now we listen to Dangling Ganglion",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
        textScaleFactor: 4,
      ),
    );
  }
}
