import 'package:fin_track/screens/login_screen/sign_in.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const _BackgroundGlow(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandChip(),
                  const SizedBox(height: 28),
                  const _HeroCard(),
                  const SizedBox(height: 28),
                  const Text(
                    'Move money with more clarity.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Track spending, review recent activity, and keep your balance in view with a cleaner personal finance flow.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _FeatureRow(
                    icon: Icons.insights_rounded,
                    title: 'Smart snapshots',
                    subtitle: 'See recent transactions and balance updates instantly.',
                  ),
                  const SizedBox(height: 14),
                  const _FeatureRow(
                    icon: Icons.lock_outline_rounded,
                    title: 'Secure sign in',
                    subtitle: 'Use email auth or Google sign-in from one place.',
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6EBF2),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Built for quick personal finance tracking',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x334DB6AC), Color(0x00000000)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: -70,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x33D6BFA7), Color(0x00000000)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandChip extends StatelessWidget {
  const _BrandChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BrandMark(),
          SizedBox(width: 10),
          Text(
            'PayU Finance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBF2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD6BFA7), Color(0xFF4DB6AC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available balance',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            '\$24,890.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(
                child: _MetricTile(
                  label: 'Income',
                  value: '+\$8,240',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  label: 'Spent',
                  value: '-\$1,420',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE6EBF2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
