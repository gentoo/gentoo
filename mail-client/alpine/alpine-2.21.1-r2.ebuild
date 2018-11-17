# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="An easy to use text-based based mail and news client"
HOMEPAGE="https://www.washington.edu/alpine/ https://repo.or.cz/alpine.git/"
GIT_COMMIT="843b2f16abfd949e09b1c5465387b1b0f724994a"
MY_P="${PN}-${GIT_COMMIT::7}"
SRC_URI="https://repo.or.cz/alpine.git/snapshot/${GIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="doc ipv6 kerberos ldap libressl nls onlyalpine pam passfile smime spell ssl threads"

DEPEND=">=sys-libs/ncurses-5.1:0=
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
	spell? ( app-text/aspell )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
RDEPEND="${DEPEND}
	app-misc/mime-types
"

HTML_DOCS=("doc/tech-notes/")

PATCHES=(
	"${FILESDIR}/${P}-nopam.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	myconf=(
		--without-tcl
		--with-system-pinerc="${EPREFIX}"/etc/pine.conf
		--with-system-fixed-pinerc="${EPREFIX}"/etc/pine.conf.fixed
		$(use_with ldap)
		$(use_with ssl)
		$(use_with passfile passfile .pinepwd)
		$(use_with kerberos krb5)
		$(use_with threads pthread)
		$(use_with spell interactive-spellcheck /usr/bin/aspell)
		$(use_enable nls)
		$(use_with ipv6)
		$(use_with smime)
		$(use_with pam)
	)

	if use ssl; then
		myconf+=(
			--with-ssl-include-dir="${EPREFIX}"/usr/include/openssl
			--with-ssl-lib-dir="${EPREFIX}"/usr/$(get_libdir)
			--with-ssl-certs-dir="${EPREFIX}"/etc/ssl/certs
		)
	fi
	econf "${myconf[@]}"
}

src_compile() {
	emake -j1 AR=$(tc-getAR)
}

src_install() {
	if use onlyalpine ; then
		dobin alpine/alpine
		doman doc/man1/alpine.1
	else
		emake -j1 DESTDIR="${D}" install
		doman doc/man1/*.1
	fi

	dodoc NOTICE README*

	if use doc ; then
		dodoc doc/brochure.txt

		dodoc doc/tech-notes/tech-notes.txt
		newdoc "${S}/doc/mailcap.unx" mailcap.unx.sample
		newdoc "${S}/doc/mime.types" mime.types.sample
		docompress -x /usr/share/doc/${PF}/mailcap.unx.sample /usr/share/doc/${PF}/mime.types.sample
	fi
}
