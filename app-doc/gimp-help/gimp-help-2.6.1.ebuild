# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="http://docs.gimp.org/"

LICENSE="FDL-1.2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

IUSE=""

# Only *not* outdated translations (see, configure.ac) are listed.
# On update do not forgive to check quickreference/Makefile.am for
# QUICKREFERENCE_ALL_LINGUAS. LANGS should include that langs too.
LANGS="de en es fr it ja ko nl nn pl ru sv zh-CN"

# Download the english translation if no l10n_* flags are enabled.
EMPTY_L10N_SRC_URI="mirror://gimp/help/${P}-html-en.tar.bz2"
for X in ${LANGS} ; do
	IUSE+=" l10n_${X}"
	SRC_URI+=" l10n_${X}? ( mirror://gimp/help/${P}-html-${X/-/_}.tar.bz2 )"
	EMPTY_L10N_SRC_URI="!l10n_${X}? ( ${EMPTY_L10N_SRC_URI} )"
done
SRC_URI="${SRC_URI} ${EMPTY_L10N_SRC_URI}"

DEPEND=""
RDEPEND=">=media-gfx/gimp-2.4"

S=${WORKDIR}/gimp-help-2/

src_compile() { :; }

src_install() {
	insinto /usr/share/gimp/2.0/help
	doins -r html/*
	dodoc AUTHORS MAINTAINERS README
}
