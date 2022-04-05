# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# sslscan builds against a static openssl library to allow weak ciphers
# to be enabled so that they can be tested.
OPENSSL_RELEASE_TAG="OpenSSL_1_1_1n"

DESCRIPTION="Fast SSL configuration scanner"
HOMEPAGE="https://github.com/rbsec/sslscan"
SRC_URI="https://github.com/rbsec/sslscan/archive/${PV}.tar.gz -> ${P}.tar.gz
		 https://github.com/openssl/openssl/archive/${OPENSSL_RELEASE_TAG}.tar.gz -> ${PN}-${OPENSSL_RELEASE_TAG}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Requires a docker environment
RESTRICT="test"

# S="${WORKDIR}/${P}-${MY_FORK}"

src_prepare() {
	ln -s ../openssl-${OPENSSL_RELEASE_TAG} openssl || die
	touch .openssl_is_fresh || die
	sed -i -e '/openssl\/.git/,/fi/d' \
		-e '/openssl test/d' Makefile || die

	# Copied from dev-libs/openssl
	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-1.0.2 gentoo.config || die
	chmod a+rx gentoo.config || die

	default
}

src_configure() {
	# Copied from dev-libs/openssl
	unset APPS #197996
	unset SCRIPTS #312551
	unset CROSS_COMPILE #311473

	tc-export CC AR RANLIB RC

	local sslout=$(./gentoo.config)
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"

	# Clean out hardcoded flags that openssl uses
	local DEFAULT_CFLAGS=$(grep ^CFLAGS= Makefile | LC_ALL=C sed \
		-e 's:^CFLAGS=::' \
		-e 's:\(^\| \)-fomit-frame-pointer::g' \
		-e 's:\(^\| \)-O[^ ]*::g' \
		-e 's:\(^\| \)-march=[^ ]*::g' \
		-e 's:\(^\| \)-mcpu=[^ ]*::g' \
		-e 's:\(^\| \)-m[^ ]*::g' \
		-e 's:^ *::' \
		-e 's: *$::' \
		-e 's: \+: :g' \
		-e 's:\\:\\\\:g'
	)

	# Now insert clean default flags with user flags
	sed -i \
		-e "/^CFLAGS=/s|=.*|=${DEFAULT_CFLAGS} ${CFLAGS}|" \
		-e "/^LDFLAGS=/s|=[[:space:]]*$|=${LDFLAGS}|" \
		Makefile || die
}

src_compile() {
	emake static
}

src_install() {
	DESTDIR="${D}" emake install

	dodoc Changelog README.md
}
