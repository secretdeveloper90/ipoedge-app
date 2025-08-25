import 'package:flutter/material.dart';
import 'dart:math' as math;

class CelebrationAnimation extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const CelebrationAnimation({
    super.key,
    required this.child,
    this.isVisible = true,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _particles = List.generate(30, (index) => ConfettiParticle());

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CelebrationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.reset();
      _particles = List.generate(30, (index) => ConfettiParticle());
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isVisible)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ConfettiPainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class ConfettiParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double rotation;
  late double rotationSpeed;
  late Color color;
  late double size;
  late ParticleShape shape;

  ConfettiParticle() {
    final random = math.Random();
    x = random.nextDouble();
    y = -0.1;
    vx = (random.nextDouble() - 0.5) * 0.5;
    vy = random.nextDouble() * 0.3 + 0.2;
    rotation = random.nextDouble() * 2 * math.pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 0.2;
    size = random.nextDouble() * 8 + 4;

    // Celebration colors
    final colors = [
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.cyan,
    ];
    color = colors[random.nextInt(colors.length)];

    final shapes = ParticleShape.values;
    shape = shapes[random.nextInt(shapes.length)];
  }

  void update(double progress) {
    y += vy * 0.02;
    x += vx * 0.02;
    rotation += rotationSpeed;
    vy += 0.001; // gravity
  }
}

enum ParticleShape {
  circle,
  square,
  triangle,
  star,
  heart,
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update(progress);

      if (particle.y > 1.2)
        continue; // Don't draw particles that are off screen

      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress * 0.7)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation);

      switch (particle.shape) {
        case ParticleShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
          break;
        case ParticleShape.square:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size,
            ),
            paint,
          );
          break;
        case ParticleShape.triangle:
          _drawTriangle(canvas, particle.size, paint);
          break;
        case ParticleShape.star:
          _drawStar(canvas, particle.size, paint);
          break;
        case ParticleShape.heart:
          _drawHeart(canvas, particle.size, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawTriangle(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, -size / 2);
    path.lineTo(-size / 2, size / 2);
    path.lineTo(size / 2, size / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final radius = size / 2;
    final innerRadius = radius * 0.4;

    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi) / 5;
      final r = i.isEven ? radius : innerRadius;
      final x = r * math.cos(angle - math.pi / 2);
      final y = r * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 20;

    path.moveTo(0, 5 * scale);
    path.cubicTo(-5 * scale, 0, -10 * scale, 0, -10 * scale, -5 * scale);
    path.cubicTo(
        -10 * scale, -10 * scale, -5 * scale, -10 * scale, 0, -5 * scale);
    path.cubicTo(5 * scale, -10 * scale, 10 * scale, -10 * scale, 10 * scale,
        -5 * scale);
    path.cubicTo(10 * scale, 0, 5 * scale, 0, 0, 5 * scale);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class FirecrackerAnimation extends StatefulWidget {
  final bool isVisible;
  final Duration duration;

  const FirecrackerAnimation({
    super.key,
    this.isVisible = true,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<FirecrackerAnimation> createState() => _FirecrackerAnimationState();
}

class _FirecrackerAnimationState extends State<FirecrackerAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FirecrackerAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: const Icon(
              Icons.celebration,
              color: Colors.orange,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
