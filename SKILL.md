# 翻译工作流

## 1. 编译

- 确定分析本项目如何编译, 然后写一个快速编译的 Makefile (编译产物放在独立文件夹)，然后用 git 初始化目录
- 目录结构:
  - paper/ (原版 tex/bbl 文件)
    - zh/ (翻译版本)
    - build/ (原版编译输出)
    - build-zh/ (中文版编译输出)
- 首先保证英文版本可以被编译，再开始翻译中文版本
- 中文版本输出的 pdf 应当选用一个有意义的，简短的名字，而不是 `paper-zh.pdf`

```bash
make zh          # 编译中文版（lualatex）
make en          # 编译英文版（pdflatex）
make cleanall    # 清理所有编译产物
make clean       # 清理原版编译产物
make clean-zh    # 清理中文版编译产物
```

中文版编译依赖：lualatex + HarfBuzz + Noto CJK 字体 + `[filename].bbl`（引用）

## 2. 翻译流程

```
选定章节 → 翻译 → make zh 编译 → 检查 PDF → 更新术语表 → git commit -> 循环往复，完成整篇文章翻译后再停下
```

- 逐节翻译，每节完成后编译验证
  - 如果要翻译的文件非常大，可拆分成 `[filename]_section{n}.tex`，再逐节翻译
- 检查项：字体渲染、数学公式、推导规则、分页断行
- 同时维护术语表 (term.md) ，格式
    ```
    # { 论文标题 }
    | 英文术语 | 中文术语 | 备注 |
    | --- | --- | --- |
    | term1 | 术语1 | 备注1 |
    | term2 | 术语2 | 备注2 |
    ```
- 一定要翻译完成再停止

### 2.1 分节标记

用 `%||||` 作为段落/小节的分隔标记。在原文被注释掉后，该标记用于分隔不同翻译单元，方便定位和比对。示例：

```latex
%||||
% This section introduces the denotational semantics.
本节引入指称语义。
%||||
```

### 2.2 保留原文

翻译时保留英文原文，用 LaTeX 注释 `%` 将原文注释掉，紧跟的中文翻译保持未注释状态。格式：

```latex
% The quick brown fox jumps over the lazy dog.
敏捷的棕色狐狸跳过了懒惰的狗。
```

用 `%||||` 包裹每个翻译单元：

```latex
%||||
% This is the first paragraph.
这是第一段。
%||||
% This is the second paragraph.
这是第二段。
%||||
```

### 2.3 漏译检查

用 ripgrep 检查是否存在未翻译的英文（非注释行中出现英文字母）：

```bash
# 带行号/上下文，方便判断是漏译还是数学公式/引用
rg -n -C 3 '^[^%].*[a-zA-Z]' zh/{filename}.tex

# JSON 格式输出，适合直接解析
rg --json '^[^%].*[a-zA-Z]' zh/{filename}.tex
```

输出为空表示所有英文原文都已被注释，翻译完整。

## 3. 翻译规范

| 类型 | 处理 |
|---|---|
| 数学符号、公式、推理规则 | 保持原文不变 |
| 人名、引用 key | 保持原文不变 |
| 技术术语 | 若原文有粗体/斜体样式，则给予同样处理，若没有则下划线处理 |
| Unicode 特殊字符 | 用 LaTeX 命令替代（如 `$\lambda$` 而非 Unicode λ） |

## 4. 注意事项

- 使用 SongTi，选择适合中文的行间距和段落间距，确保排版美观
- **不要**手动调用 `\setmainfont`/`\setsansfont`/`\setmonofont`，会覆盖 acmart 的 Linux Libertine 设置
- CJK 字体用 `\setCJKmainfont`/`\setCJKsansfont`/`\setCJKmonofont`
