# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 perl-module

EGIT_REPO_URI="git://git.code.sf.net/p/clusterssh/code"
EGIT_PROJECT="${PN}"

DESCRIPTION="Concurrent Multi-Server Terminal Access"
HOMEPAGE="http://clusterssh.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

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
	git-2_src_unpack
	perl-module_src_unpack
}
