# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=2.20
inherit bash-completion-r1 perl-module

DESCRIPTION="Handy web browsing in a Perl object"

SLOT="0"
KEYWORDS="amd64 arm ppc ~riscv x86"

RDEPEND="
	>=dev-perl/HTML-Form-6.80.0
	dev-perl/HTML-Parser
	>=dev-perl/HTML-Tree-5
	dev-perl/HTTP-Cookies
	>=dev-perl/HTTP-Message-7.10.0
	>=dev-perl/libwww-perl-6.450.0
	dev-perl/URI
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/HTTP-Daemon-6.120.0
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Memory-Cycle
		dev-perl/Test-Output
		dev-perl/Test-Warnings
	)
"

src_install() {
	perl-module_src_install
	dobashcomp contrib/bash-completion/completions/mech-dump
}
