# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils multilib qt4-r2

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="aqua debug doc examples gpg logger +openssl pkcs11 sasl"
RESTRICT="test"

DEPEND="dev-qt/qtcore:4[debug?]"
RDEPEND="${DEPEND}
	!<app-crypt/qca-1.0-r3:0"

PDEPEND="gpg? ( app-crypt/qca-gnupg )
	logger? ( app-crypt/qca-logger )
	openssl? ( app-crypt/qca-ossl )
	pkcs11? ( app-crypt/qca-pkcs11 )
	sasl? ( app-crypt/qca-cyrus-sasl )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.2-pcfilespath.patch \
		"${FILESDIR}"/${P}+gcc-4.7.patch

	if use aqua; then
		sed -i -e "s|QMAKE_LFLAGS_SONAME =.*|QMAKE_LFLAGS_SONAME = -Wl,-install_name,|g" \
			src/src.pro || die
	fi
}

src_configure() {
	# Ensure proper rpath
	export EXTRA_QMAKE_RPATH="${EPREFIX}/usr/$(get_libdir)/qca2"

	ABI= ./configure \
		--prefix="${EPREFIX}"/usr \
		--qtdir="${EPREFIX}"/usr \
		--includedir="${EPREFIX}"/usr/include/qca2 \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/qca2 \
		--certstore-path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		--no-separate-debug-info \
		--disable-tests \
		--$(use debug && echo debug || echo release) \
		--no-framework \
		|| die "configure failed"

	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die
	dodoc README TODO || die

	cat <<-EOF > "${WORKDIR}"/44qca2
	LDPATH="${EPREFIX}/usr/$(get_libdir)/qca2"
	EOF
	doenvd "${WORKDIR}"/44qca2 || die

	if use doc; then
		dohtml "${S}"/apidocs/html/* || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples || die
	fi

	# add the proper rpath for packages that do CONFIG += crypto
	echo "QMAKE_RPATHDIR += \"${EPREFIX}/usr/$(get_libdir)/qca2\"" >> \
		"${D%/}${EPREFIX}/usr/share/qt4/mkspecs/features/crypto.prf" \
		|| die "failed to add rpath to crypto.prf"
}
