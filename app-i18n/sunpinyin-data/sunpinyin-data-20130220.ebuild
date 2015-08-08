# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DICT_VERSION="${PV}"
LM_VERSION="20121025"

DESCRIPTION="Data sets for Sunpinyin"
HOMEPAGE="https://open-gram.googlecode.com/"
SRC_URI="http://open-gram.googlecode.com/files/dict.utf8-${DICT_VERSION}.tar.bz2
	http://open-gram.googlecode.com/files/lm_sc.t3g.arpa-${LM_VERSION}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE=""

DEPEND=">=app-i18n/sunpinyin-2.0.4_pre20130108"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	mkdir "${S}" || die
	mv "${WORKDIR}"/dict.utf8 "${S}" || die
	mv "${WORKDIR}"/lm_sc.t3g.arpa "${S}" || die
	cp "${FILESDIR}"/SLM-inst.mk "${S}"/Makefile || die
}

src_compile() {
	# we don't have any big-endian architectures keyworded yet, so hardcode
	emake ENDIANNESS=le
}

src_install() {
	emake ENDIANNESS=le DESTDIR="${D}" install
}
