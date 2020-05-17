# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL="1"
DISTUTILS_USE_SETUPTOOLS="no"

inherit distutils-r1 perl-module toolchain-funcs

DESCRIPTION="Network Kanji code conversion Filter with UTF-8/16 support"
HOMEPAGE="https://osdn.net/projects/nkf/"
SRC_URI="mirror://sourceforge.jp/${PN}/59912/${P}.tar.gz
	l10n_ja? ( https://dev.gentoo.org/~naota/files/${PN}.1j )
	python? ( https://dev.gentoo.org/~naota/files/NKF_python20090602.tgz )"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x86-macos"
IUSE="perl python l10n_ja"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e "/^CFLAGS/{ s/-g -O2//; s/=/+=/; }" \
		-e "/ -o ${PN}/s/\(-o \)/\$(LDFLAGS) \1/" \
		Makefile
	if use l10n_ja; then
		cp "${DISTDIR}"/${PN}.1j ${PN}.ja.1 || die
	fi
	if use python; then
		mv "${WORKDIR}"/NKF.python . || die
		eapply "${FILESDIR}"/${P}-strip.patch
		cd NKF.python
		distutils-r1_src_prepare
		cd - >/dev/null
	fi

	default
}

src_configure() {
	default
	if use perl; then
		cd NKF.mod
		perl-module_src_configure
		cd - >/dev/null
	fi
	if use python; then
		cd NKF.python
		distutils-r1_src_configure
		cd - >/dev/null
	fi
}

src_compile() {
	emake CC="$(tc-getCC)"
	if use perl; then
		cd NKF.mod
		perl-module_src_compile
		cd - >/dev/null
	fi
	if use python; then
		cd NKF.python
		distutils-r1_src_compile
		cd - >/dev/null
	fi
}

src_test() {
	default
	if use perl; then
		cd NKF.mod
		perl-module_src_test
		cd - >/dev/null
	fi
}

src_install() {
	dobin ${PN}
	doman ${PN}.1

	if use l10n_ja; then
		doman ${PN}.ja.1
	fi
	dodoc ${PN}.doc

	if use perl; then
		cd NKF.mod
		docinto perl
		perl-module_src_install
		cd - >/dev/null
	fi
	if use python; then
		cd NKF.python
		docinto python
		DOCS= distutils-r1_src_install
		dodoc README
		cd - >/dev/null
	fi
}
