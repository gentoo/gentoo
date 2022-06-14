# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for pandoc"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=""
RDEPEND="|| ( app-text/pandoc-bin[pandoc-symlink] app-text/pandoc )"
