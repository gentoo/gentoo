# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="App-ClusterSSH"
MODULE_AUTHOR="DUNCS"
###################
# /!\ IMPORTANT /!\
###################
# CHANGE ME AT EVERY VERSION BUMP
MODULE_VERSION="4.03_06"

inherit eutils perl-module

DESCRIPTION="Concurrent Multi-Server Terminal Access"
HOMEPAGE="https://github.com/duncs/clusterssh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Config-Simple
	dev-perl/Exception-Class
	dev-perl/Tk
	dev-perl/Readonly
	dev-perl/Test-DistManifest
	dev-perl/Test-Pod
	dev-perl/Test-Pod-Coverage
	dev-perl/Test-Trap
	dev-perl/Try-Tiny
	dev-perl/X11-Protocol
	dev-perl/XML-Simple
	x11-apps/xlsfonts
	x11-terms/xterm"
DEPEND="
	${RDEPEND}
	dev-perl/CPAN-Changes
	dev-perl/File-Slurp
	dev-perl/File-Which
	dev-perl/Module-Build
	dev-perl/Test-Differences
	dev-perl/Test-Pod"

SRC_TEST="do parallel"
