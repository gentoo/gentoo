# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for pandoc"

SLOT="0"
KEYWORDS="amd64 arm64 ~riscv ~x86"

RDEPEND="|| ( app-text/pandoc-bin[pandoc-symlink] app-text/pandoc-cli app-text/pandoc )"
