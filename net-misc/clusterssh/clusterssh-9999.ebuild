# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 perl-module

EGIT_REPO_URI="git://git.code.sf.net/p/clusterssh/code"

DESCRIPTION="Concurrent Multi-Server Terminal Access"
HOMEPAGE="https://github.com/duncs/clusterssh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Exception-Class
	dev-perl/Readonly
	dev-perl/Test-Pod
	dev-perl/Test-Pod-Coverage
	dev-perl/Test-Trap
	dev-perl/Test-DistManifest
	dev-perl/Try-Tiny
	dev-perl/Tk
	dev-perl/Config-Simple
	dev-perl/X11-Protocol
	dev-perl/XML-Simple
	x11-apps/xlsfonts
	x11-terms/xterm"
DEPEND="
	${RDEPEND}
	dev-perl/File-Which
	dev-perl/Module-Build
	dev-perl/Test-Pod
	test? ( dev-perl/Test-Differences )"

SRC_TEST="do parallel"

src_unpack() {
	git-r3_src_unpack
	perl-module_src_unpack
}
