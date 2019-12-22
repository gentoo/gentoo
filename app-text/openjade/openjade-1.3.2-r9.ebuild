# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic sgml-catalog-r1 toolchain-funcs

DESCRIPTION="Jade is an implementation of DSSSL for formatting SGML and XML documents"
HOMEPAGE="http://openjade.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	app-text/sgml-common
	>=app-text/opensp-1.5.1
"
DEPEND="${RDEPEND}
	dev-lang/perl
"

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-deplibs.patch
	eapply "${FILESDIR}"/${P}-ldflags.patch
	eapply "${FILESDIR}"/${P}-msggen.pl.patch
	eapply "${FILESDIR}"/${P}-respect-ldflags.patch
	eapply "${FILESDIR}"/${P}-libosp-la.patch
	eapply "${FILESDIR}"/${P}-gcc46.patch
	eapply "${FILESDIR}"/${P}-no-undefined.patch
	eapply "${FILESDIR}"/${P}-wchar_t-uint.patch
	eapply "${FILESDIR}"/${P}-chmod.patch #487218

	# Please note!  Opts are disabled.  If you know what you're doing
	# feel free to remove this line.  It may cause problems with
	# docbook-sgml-utils among other things.
	#ALLOWED_FLAGS="-O -O1 -O2 -pipe -g -march"
	strip-flags

	# Default CFLAGS and CXXFLAGS is -O2 but this make openjade segfault
	# on hppa. Using -O1 works fine. So I force it here.
	use hppa && replace-flags -O2 -O1

	ln -s config/configure.in configure.ac || die
	cp "${FILESDIR}"/${P}-acinclude.m4 acinclude.m4 || die
	rm config/missing || die

	AT_NOEAUTOMAKE=yes \
	eautoreconf
}

src_configure() {
	# avoids dead-store elimination optimization
	# leading to segfaults on GCC 6
	# bug #592590 #596506
	tc-is-clang || append-cxxflags $(test-flags-CXX -fno-lifetime-dse)

	# We need Prefix env, bug #287358
	CONFIG_SHELL="${CONFIG_SHELL:-${BASH}}" \
	econf \
		--enable-http \
		--enable-default-catalog="${EPREFIX}"/etc/sgml/catalog \
		--enable-default-search-path="${EPREFIX}"/usr/share/sgml \
		--enable-splibdir="${EPREFIX}"/usr/$(get_libdir) \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--datadir="${EPREFIX}"/usr/share/sgml/${P} \
		--disable-static
}

src_compile() {
	unset INCLUDE #412725
	emake -j1 SHELL="${BASH}"
}

src_install() {
	#dodir /usr/$(get_libdir)

	make DESTDIR="${D}" \
		SHELL="${BASH}" \
		libdir="${EPREFIX}"/usr/$(get_libdir) \
		install install-man

	find "${D}" -name '*.la' -delete || die

	dosym openjade /usr/bin/jade
	dosym onsgmls /usr/bin/nsgmls
	dosym osgmlnorm /usr/bin/sgmlnorm
	dosym ospam /usr/bin/spam
	dosym ospent /usr/bin/spent
	dosym osx /usr/bin/sgml2xml

	insinto /usr/share/sgml/${P}
	doins dsssl/builtins.dsl

	newins - catalog <<-EOF
		SYSTEM "builtins.dsl" "builtins.dsl"
	EOF
	doins -r pubtext
	insinto /usr/share/sgml/${P}/dsssl
	doins dsssl/{dsssl.dtd,style-sheet.dtd,fot.dtd}
	newins "${FILESDIR}"/${P}.dsssl-catalog catalog

	# Breaks sgml2xml among other things
	#insinto /usr/share/sgml/${P}/unicode
	#doins unicode/{catalog,unicode.sd,unicode.syn,gensyntax.pl}

	insinto /etc/sgml
	newins - "${P}.cat" <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/openjade-${PV}/catalog"
		CATALOG "${EPREFIX}/usr/share/sgml/openjade-${PV}/dsssl/catalog"
	EOF

	local HTML_DOCS=( doc/*.htm )
	einstalldocs
	dodoc -r jadedoc
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/${P}.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/${P}.cat
	local real=${EROOT}/etc/sgml/${P}.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	# this one's shared with docbook-dsssl, so we need to do it in postinst
	if ! grep -q -s ${P}.cat \
			"${EROOT}"/etc/sgml/sgml-docbook.cat; then
		ebegin "Adding ${P}.cat to /etc/sgml/sgml-docbook.cat"
		cat >> "${EROOT}"/etc/sgml/sgml-docbook.cat <<-EOF
			CATALOG "${EPREFIX}/etc/sgml/${P}.cat"
		EOF
		eend ${?}
	fi
	sgml-catalog-r1_pkg_postinst
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		ebegin "Removing ${P}.cat from /etc/sgml/sgml-docbook.cat"
		sed -i -e '/${P}/d' \
			"${EROOT}"/etc/sgml/sgml-docbook.cat
		eend ${?}
		if [[ ! -s ${EROOT}/etc/sgml/sgml-docbook.cat ]]; then
			rm -f "${EROOT}"/etc/sgml/sgml-docbook.cat
		fi
	fi
	sgml-catalog-r1_pkg_postrm
}
