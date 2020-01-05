# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 perl-module toolchain-funcs vcs-snapshot

PY_P="python-${PN}-0.2.0_p20141211"
PY_COMMIT="000915e115acac57a1fdbceb1e6361788af83a3d"

DESCRIPTION="Network Kanji code conversion Filter with UTF-8/16 support"
HOMEPAGE="https://ja.osdn.net/projects/nkf/"
SRC_URI="mirror://sourceforge.jp/${PN}/64158/${P}.tar.gz
	python? ( https://github.com/fumiyas/python-${PN}/archive/${PY_COMMIT}.tar.gz -> ${PY_P}.tar.gz )"

LICENSE="ZLIB python? ( BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-macos"
IUSE="perl python l10n_ja"

src_prepare() {
	sed -i \
		-e "/^CFLAGS/{ s/-g -O2//; s/=/+=/; }" \
		-e "/ -o ${PN}/s/\(-o \)/\$(LDFLAGS) \1/" \
		Makefile
	if use python; then
		mv "${WORKDIR}"/${PY_P} NKF.python || die
		eapply "${FILESDIR}"/${P}-python.patch
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
