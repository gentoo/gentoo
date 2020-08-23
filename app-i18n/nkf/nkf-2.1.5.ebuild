# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_OPTIONAL="1"
DISTUTILS_USE_SETUPTOOLS="no"

inherit distutils-r1 perl-module toolchain-funcs vcs-snapshot

PY_P="python-${PN}-0.2.0_p20191121"
PY_COMMIT="c2c6724714b66f295137c8818dae4c09fc09e0a3"

DESCRIPTION="Network Kanji code conversion Filter with UTF-8/16 support"
HOMEPAGE="https://osdn.net/projects/nkf/"
SRC_URI="mirror://sourceforge.jp/${PN}/70406/${P}.tar.gz
	python? ( https://github.com/fumiyas/python-${PN}/archive/${PY_COMMIT}.tar.gz -> ${PY_P}.tar.gz )"

LICENSE="ZLIB python? ( BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-macos"
IUSE="perl python l10n_ja"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)"
DEPEND="${RDEPEND}"

src_unpack() {
	use python && vcs-snapshot_src_unpack || default
}

src_prepare() {
	sed -i \
		-e "/^CFLAGS/{ s/-g -O2//; s/=/+=/; }" \
		-e "/ -o ${PN}/s/\(-o \)/\$(LDFLAGS) \1/" \
		Makefile
	if use python; then
		mv "${WORKDIR}"/${PY_P} NKF.python || die
		eapply "${FILESDIR}"/${PN}-python.patch
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
		iconv -f ISO-2022-JP-3 -t UTF-8 ${PN}.1j > ${PN}.ja.1 || die
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
		dodoc CHANGES README.md
		cd - >/dev/null
	fi
}
