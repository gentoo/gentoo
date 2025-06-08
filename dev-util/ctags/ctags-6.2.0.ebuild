# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools python-any-r1

DESCRIPTION="Exuberant Ctags creates tags files for code browsing in editors"
HOMEPAGE="https://ctags.io/ https://github.com/universal-ctags/ctags"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/universal-ctags/ctags"
	inherit git-r3
elif [[ ${PV} == *.*_p*_p* ]] ; then
	# 6.0_p20230423_p0
	#
	# 6.0
	MY_PV_BASE=${PV/_p/.}
	MY_PV_BASE=${MY_PV_BASE%*.*}
	# 20230423_p0
	MY_PV_PATCH=${PV#*_p}
	# 20230423
	MY_PV_PATCH_DATE=${MY_PV_PATCH%_p*}
	# 0
	MY_PV_PATCH_DATE_SUFFIX=${MY_PV_PATCH##*_p}
	# p6.0.20230423.0
	MY_PV=p${MY_PV_BASE}.${MY_PV_PATCH_DATE}.${MY_PV_PATCH_DATE_SUFFIX}
	MY_P=${PN}-${MY_PV}

	SRC_URI="https://github.com/universal-ctags/ctags/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
else
	SRC_URI="https://github.com/universal-ctags/ctags/releases/download/v${PV}/universal-${P}.tar.gz"
	S="${WORKDIR}"/universal-${P}
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="json pcre seccomp test xml yaml"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi
RESTRICT="!test? ( test )"

DEPEND="
	json? ( dev-libs/jansson:= )
	pcre? ( dev-libs/libpcre2 )
	seccomp? ( sys-libs/libseccomp )
	xml? ( dev-libs/libxml2:2 )
	yaml? ( dev-libs/libyaml )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-python/docutils
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"
IDEPEND="app-eselect/eselect-ctags"

QA_CONFIG_IMPL_DECL_SKIP=(
	# manual check for function in a library that doesn't exist, passes -liconv
	# which either fails to link anyway (glibc) or passes this check (musl)
	libiconv_open
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# Ignore check-genfile test (calls git which errors out)
	sed -i 's/man-test check-genfile/man-test/' makefiles/testing.mak || die

	# Don't automagically use Valgrind
	sed -i -e '/if type valgrind/s:valgrind:valgrind-falseified:' Tmain/optscript.d/run.sh || die
	#./misc/dist-test-cases > makefiles/test-cases.mak || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable json)
		$(use_enable pcre pcre2)
		$(use_enable seccomp)
		$(use_enable xml)
		$(use_enable yaml)
		--disable-etags
		--enable-tmpdir="${EPREFIX}"/tmp
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake prefix="${ED}"/usr mandir="${ED}"/usr/share/man install

	# Namepace collision with X/Emacs-provided /usr/bin/ctags -- we
	# rename ctags to exuberant-ctags (Mandrake does this also).
	mv "${ED}"/usr/bin/{ctags,exuberant-ctags} || die
	mv "${ED}"/usr/share/man/man1/{ctags,exuberant-ctags}.1 || die
}

pkg_postinst() {
	eselect ctags update

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "You can set the version to be started by ${EROOT}/usr/bin/ctags through"
		elog "the ctags eselect module. \"man ctags.eselect\" for details."
	fi
}

pkg_postrm() {
	eselect ctags update
}
