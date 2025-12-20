# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
	ECVS_SERVER="anoncvs.mirbsd.org:/cvs"
	ECVS_MODULE="mksh"
	ECVS_USER="_anoncvs"
	ECVS_AUTH="ext"
	ECVS_SSH_EXTRA_OPTS=( "-oHostKeyAlgorithms=+ssh-rsa" )
	inherit cvs
else
	SRC_URI="https://www.mirbsd.org/MirOS/dist/mir/mksh/${PN}-R${PV}.tgz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="MirBSD Korn Shell"
# Host is TLSv1.0-only, keep to http for compatibility with modern browsers
HOMEPAGE="http://mirbsd.de/mksh"
S="${WORKDIR}/${PN}"

# See http://www.mirbsd.org/TaC-mksh.txt or ${S}/www/files/TaC-mksh.txt
# MirOS for most of it
# BSD for when strlcpy(3) is absent, such as with glibc
# unicode for some included Unicode data
# ISC if the printf builtin is used, not currently the case
LICENSE="MirOS BSD unicode"
SLOT="0"
IUSE="lksh static test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-lang/perl
		sys-apps/ed
	)
"

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
	sh FAQ2HTML.sh || die
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

src_install() {
	into /
	dobin mksh
	dosym mksh /bin/rmksh
	doman mksh.1
	dodoc dot.mkshrc
	dodoc FAQ.htm

	if use lksh; then
		dobin "${S}"_lksh/lksh
		dosym lksh /bin/rlksh
		doman "${S}"_lksh/lksh.1
	fi
}
