# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/hyperestraier/hyperestraier-1.4.13.ebuild,v 1.15 2014/07/08 00:52:07 naota Exp $

inherit java-pkg-opt-2 multilib

IUSE="debug java mecab ruby"

DESCRIPTION="a full-text search system for communities"
HOMEPAGE="http://fallabs.com/hyperestraier/"
SRC_URI="http://fallabs.com/hyperestraier/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
SLOT="0"

RDEPEND=">=dev-db/qdbm-1.8.75
	sys-libs/zlib
	java? ( >=virtual/jre-1.4 )
	mecab? ( app-text/mecab )
	ruby? ( dev-lang/ruby )"
DEPEND="${RDEPEND}
	java? ( >=virtual/jdk-1.4 )"

src_unpack() {

	unpack ${A}
	cd "${S}"

	# fix for insecure runpath warning.
	sed -i \
		-e "/^LDENV/d" \
		-e "/^CFLAGS/s/$/ ${CFLAGS}/" \
		Makefile.in \
		|| die
	sed -i "/^JAVACFLAGS/s/$/ ${JAVACFLAGS}/" java*/Makefile.in || die

}

src_compile() {

	econf \
		$(use_enable debug) \
		$(use_enable mecab) \
		|| die
	emake || die

	local u d

	for u in java ruby; do
		if ! use ${u}; then
			continue
		fi

		for d in ${u}native ${u}pure; do
			cd ${d}
			econf || die
			emake || die
			cd -
		done
	done

}

src_test() {

	emake -j1 check || die

	local u d

	for u in java ruby; do
		if ! use ${u}; then
			continue
		fi

		for d in ${u}native; do
			cd ${d}
			emake -j1 check || die
			cd -
		done
	done

}

src_install() {

	emake DESTDIR="${D}" MYDOCS= install || die
	dodoc ChangeLog README* THANKS
	dohtml doc/{*.html,*.png}

	local u d

	for u in java ruby; do
		if ! use ${u}; then
			continue
		fi

		for d in ${u}native ${u}pure; do
			cd ${d}
			emake DESTDIR="${D}" install || die
			cd -
			dohtml -r doc/${d}api
		done
	done

	if use java; then
		java-pkg_dojar "${D}"/usr/$(get_libdir)/*.jar
		rm -f "${D}"/usr/$(get_libdir)/*.jar
	fi

	rm -f "${D}"/usr/bin/*test

}
