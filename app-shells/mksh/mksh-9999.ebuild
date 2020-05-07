# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
	inherit cvs
	ECVS_SERVER="anoncvs.mirbsd.org:/cvs"
	ECVS_MODULE="mksh"
	ECVS_USER="_anoncvs"
	ECVS_AUTH="ext"
else
	SRC_URI="https://www.mirbsd.org/MirOS/dist/mir/mksh/${PN}-R${PV}.tgz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MirBSD Korn Shell"
# Host is TLSv1.0-only, keep to http for compatibility with modern browsers
HOMEPAGE="http://mirbsd.de/mksh"

LICENSE="BSD"
SLOT="0"
IUSE="lksh static test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-lang/perl
		sys-apps/ed
	)
"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	if use lksh; then
		cp -pr "${S}" "${S}"_lksh || die
	fi
}

src_compile() {
	tc-export CC
	use static && export LDSTATIC="-static"
	export CPPFLAGS="${CPPFLAGS} -DMKSH_DEFAULT_PROFILEDIR=\\\"${EPREFIX}/etc\\\""

	if use lksh; then
		pushd "${S}"_lksh >/dev/null || die
		CPPFLAGS="${CPPFLAGS} -DMKSH_BINSHPOSIX -DMKSH_BINSHREDUCED" \
			sh Build.sh -r -L || die
		popd >/dev/null || die
	fi

	sh Build.sh -r || die
}

src_install() {
	into /
	dobin mksh
	doman mksh.1
	dodoc dot.mkshrc
	dosym mksh /bin/rmksh

	if use lksh; then
		dobin "${S}"_lksh/lksh
		doman "${S}"_lksh/lksh.1
	fi
}

src_test() {
	einfo "Testing regular mksh."
	./mksh test.sh -v || die

	if use lksh; then
		einfo "Testing lksh, POSIX long-bit mksh."
		pushd "${S}"_lksh >/dev/null || die
		./lksh test.sh -v || die
		popd >/dev/null || die
	fi
}
