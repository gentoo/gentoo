# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/aspell-dict.eclass,v 1.44 2014/01/05 11:39:48 pacho Exp $

# @ECLASS: aspell-dict.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
# @BLURB: An eclass to streamline the construction of ebuilds for new aspell dicts
# @DESCRIPTION:
# The aspell-dict eclass is designed to streamline the construction of
# ebuilds for the new aspell dictionaries (from gnu.org) which support
# aspell-0.50. Support for aspell-0.60 has been added by Sergey Ulanov.

# @ECLASS-VARIABLE: ASPELL_LANG
# @REQUIRED
# @DESCRIPTION:
# Which language is the dictionary for? It's used for the DESCRIPTION of the
# package.

# @ECLASS-VARIABLE: ASPOSTFIX
# @REQUIRED
# @DESCRIPTION:
# What major version of aspell is this dictionary for?

EXPORT_FUNCTIONS src_compile src_install

#MY_P=${PN}-${PV%.*}-${PV#*.*.}
MY_P=${P%.*}-${PV##*.}
MY_P=aspell${ASPOSTFIX}-${MY_P/aspell-/}
SPELLANG=${PN/aspell-/}
S="${WORKDIR}/${MY_P}"
DESCRIPTION="${ASPELL_LANG} language dictionary for aspell"
HOMEPAGE="http://aspell.net"
SRC_URI="mirror://gnu/aspell/dict/${SPELLANG}/${MY_P}.tar.bz2"

IUSE=""
SLOT="0"

if [ x${ASPOSTFIX} = x6 ] ; then
	RDEPEND=">=app-text/aspell-0.60"
	DEPEND="${RDEPEND}"
else
	RDEPEND=">=app-text/aspell-0.50"
	DEPEND="${RDEPEND}"
fi

# @FUNCTION: aspell-dict_src_compile
# @DESCRIPTION:
# The aspell-dict src_compile function which is exported.
aspell-dict_src_compile() {
	./configure || die
	emake || die
}

# @FUNCTION: aspell-dict_src_install
# @DESCRIPTION:
# The aspell-dict src_install function which is exported.
aspell-dict_src_install() {
	make DESTDIR="${D}" install || die

	for doc in README info ; do
		[ -s "$doc" ] && dodoc $doc
	done
}
