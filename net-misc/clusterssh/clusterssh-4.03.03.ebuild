# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="App-ClusterSSH"
MODULE_AUTHOR="DUNCS"
MODULE_VERSION="4.01_05"

inherit eutils perl-module versionator

DESCRIPTION="Concurrent Multi-Server Terminal Access"
HOMEPAGE="http://clusterssh.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
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
	dev-perl/Test-Differences"

#S="${WORKDIR}"/${MY_P}

SRC_TEST="do parallel"

src_prepare() {
	# broken test, check again for new releases
	sed \
		-e '/boilerplate/d' \
		-e '/manifest.t/d' \
		-i MANIFEST || die
	rm t/boilerplate.t t/manifest.t || die

	perl-module_src_prepare
}
