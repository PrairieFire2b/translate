# 翻译工作流

## 1. 编译

- 确定分析本项目如何编译, 然后写一个快速编译的 Makefile (编译产物放在独立文件夹)，然后用 git 初始化目录
- 目录结构
  - 中文翻译版本放到 zh/
  - 英文版本编译输出到 build/ ; 中文输出到 build-zh/ 
- 首先保证英文版本可以被编译，再开始翻译中文版本

```bash
make zh          # 编译中文版（lualatex，输出到 build-zh/）
make en          # 编译英文版（pdflatex，输出到 build/）
make cleanall    # 清理编译产物
make clean       # 清理原版编译产物
make clean-zh    # 清理中文版编译产物
```

中文版编译依赖：lualatex + HarfBuzz + Noto CJK 字体 + `[filename].bbl`

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

## 3. 翻译规范

| 类型 | 处理 |
|---|---|
| 数学符号、公式、推理规则 | 保持原文不变 |
| 人名、引用 key | 保持原文不变 |
| 技术术语 | 若原文有粗体/斜体样式，则给予同样处理 |
| Unicode 特殊字符 | 用 LaTeX 命令替代（如 `$\lambda$` 而非 Unicode λ） |

## 4. 注意事项

- 使用 SongTi，选择适合中文的行间距和段落间距，确保排版美观
- **不要**手动调用 `\setmainfont`/`\setsansfont`/`\setmonofont`，会覆盖 acmart 的 Linux Libertine 设置
- CJK 字体用 `\setCJKmainfont`/`\setCJKsansfont`/`\setCJKmonofont`
