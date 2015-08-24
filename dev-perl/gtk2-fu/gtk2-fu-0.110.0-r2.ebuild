# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Gtk2Fu
MODULE_AUTHOR=DAMS
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="gtk2-fu is a layer on top of perl gtk2, that brings power, simplicity and speed of development"
SRC_URI+="
https://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${MY_PN:-${PN}}/${MY_PN:-${PN}}-${PV}-patch.tar.bz2"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 x86"
IUSE="test"

RDEPEND="dev-perl/gtk2-perl"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
EPATCH_SUFFIX=patch
PATCHES=(
	"${WORKDIR}"/${MY_PN:-${PN}}-patch
)

PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
