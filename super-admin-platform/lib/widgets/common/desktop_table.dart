import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class DesktopTableColumn {
  final String label;
  final int flex;
  final TextAlign align;

  const DesktopTableColumn({
    required this.label,
    this.flex = 1,
    this.align = TextAlign.start,
  });
}

class DesktopTable extends StatelessWidget {
  final List<DesktopTableColumn> columns;
  final List<List<Widget>> rows;
  final Widget? emptyWidget;

  const DesktopTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderRow(columns: columns),
        ...rows.map((cells) => _DataRow(columns: columns, cells: cells)),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final List<DesktopTableColumn> columns;

  const _HeaderRow({required this.columns});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder, width: 1)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Expanded(
              flex: columns[i].flex,
              child: Text(
                columns[i].label.toUpperCase(),
                textAlign: columns[i].align,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DataRow extends StatefulWidget {
  final List<DesktopTableColumn> columns;
  final List<Widget> cells;

  const _DataRow({required this.columns, required this.cells});

  @override
  State<_DataRow> createState() => _DataRowState();
}

class _DataRowState extends State<_DataRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceLight.withValues(alpha: 0.5) : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AppColors.glassBorder, width: 1)),
        ),
        child: Row(
          children: [
            for (var i = 0; i < widget.columns.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(
                flex: widget.columns[i].flex,
                child: Align(
                  alignment: _alignment(widget.columns[i].align),
                  child: i < widget.cells.length ? widget.cells[i] : const SizedBox.shrink(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Alignment _alignment(TextAlign align) {
    switch (align) {
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }
}
