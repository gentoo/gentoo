# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Password hashing software that won the Password Hashing Competition (PHC)"
HOMEPAGE="https://github.com/P-H-C/phc-winner-argon2"
SRC_URI="https://github.com/P-H-C/phc-winner-argon2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 CC0-1.0 )"
SLOT="0/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="static-libs"

S="${WORKDIR}/phc-winner-${P}"

DOCS=( argon2-specs.pdf CHANGELOG.md README.md )

src_prepare() {
	default
	if ! use static-libs; then
		sed -i -e '/LIBRARIES =/s/\$(LIB_ST)//' Makefile || die
	fi
	sed -i \
		-e 's/-O3//' \
		-e 's/-g//' \
		-e 's/-march=\$(OPTTARGET)//' \
		Makefile || die

	tc-export CC

	OPTTEST=1
	if use amd64 || use x86; then
		$(tc-getCPP) ${CFLAGS} ${CPPFLAGS} -P - <<-EOF &>/dev/null && OPTTEST=0
			#if defined(__SSE2__)
			true
			#else
			#error false
			#endif
		EOF
	fi
}

src_compile() {
	emake OPTTEST="${OPTTEST}" LIBRARY_REL="$(get_libdir)" \
		ARGON2_VERSION="0~${PV}"
}

src_test() {
	emake OPTTEST="${OPTTEST}" test
}

src_install() {
	emake OPTTEST="${OPTTEST}" DESTDIR="${ED}" LIBRARY_REL="$(get_libdir)" install
	einstalldocs
	doman man/argon2.1
}
