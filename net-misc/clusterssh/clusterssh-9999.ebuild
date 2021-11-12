# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Concurrent Multi-Server Terminal Access"
HOMEPAGE="https://github.com/duncs/clusterssh"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/duncs/clusterssh"
	inherit git-r3
else
	DIST_AUTHOR="DUNCS"
	DIST_NAME="App-ClusterSSH"
	# Use dev-perl/Gentoo-PerlMod-Version to update this on bumps!
	# DIST_VERSION=$(gentoo-perlmod-version.pl ${UPSTREAM_VERSION})
	#DIST_VERSION="$(ver_cut 1-2)"
	#die "|$(ver_cut 1-2)_$(ver_cut 3)|"

	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

inherit perl-module

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Config-Simple
	dev-perl/Exception-Class
	dev-perl/Readonly
	dev-perl/Sort-Naturally
	dev-perl/Test-DistManifest
	dev-perl/Test-Pod
	dev-perl/Test-Pod-Coverage
	dev-perl/Test-Trap
	dev-perl/Tk
	dev-perl/Try-Tiny
	dev-perl/X11-Protocol
	dev-perl/X11-Protocol-Other
	dev-perl/XML-Simple
	x11-apps/xlsfonts
	x11-terms/xterm
	"
BDEPEND="
	${RDEPEND}
	dev-perl/CPAN-Changes
	dev-perl/File-Slurp
	dev-perl/File-Which
	dev-perl/Module-Build
	dev-perl/Test-Differences
	dev-perl/Test-Pod"

SRC_TEST="do parallel"
