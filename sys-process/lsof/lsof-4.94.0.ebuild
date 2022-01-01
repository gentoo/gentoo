# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${P/-/_}"
DESCRIPTION="Lists open files for running Unix processes"
HOMEPAGE="https://github.com/lsof-org/lsof"
SRC_URI="https://github.com/lsof-org/lsof/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="lsof"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples ipv6 rpc selinux"

RDEPEND="rpc? ( net-libs/libtirpc )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/groff
	rpc? ( virtual/pkgconfig )
"

# needs fixing first
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-4.85-cross.patch #432120
)

src_prepare() {
	default
	# fix POSIX compliance with `echo`
	sed -i \
		-e 's:echo -n:printf:' \
		AFSConfig Configure Customize Inventory tests/CkTestDB || die
	# Convert `test -r header.h` into a compile test.
	# Make sure we convert `test ... -a ...` into two `test` commands
	# so we can then convert both over into a compile test. #601432
	sed -i -E \
		-e '/if test .* -a /s: -a : \&\& test :g' \
		-e '/test -r/s:test -r \$\{LSOF_INCLUDE\}/([[:alnum:]/._]*):echo "#include <\1>" | ${LSOF_CC} ${LSOF_CFGF} -E - >/dev/null 2>\&1:g' \
		-e 's:grep (.*) \$\{LSOF_INCLUDE\}/([[:alnum:]/._]*):echo "#include <\2>" | ${LSOF_CC} ${LSOF_CFGF} -E -P -dD - 2>/dev/null | grep \1:' \
		Configure || die

	# "create" man-page (bug #689462)
	# inspired by shipped "makeman" ksh script
	soelim < Lsof.8 > lsof.8 || die
}

target() {
	case ${CHOST} in
	*-darwin*)  echo darwin  ;;
	*-freebsd*) echo freebsd ;;
	*-solaris*) echo solaris ;;
	*-aix*)     echo aixgcc  ;;
	*)          echo linux   ;;
	esac
}

src_configure() {
	append-cppflags $(use rpc && $(tc-getPKG_CONFIG) libtirpc --cflags || echo "-DHASNOTRPC -DHASNORPC_H")
	append-cppflags $(usex ipv6 -{D,U}HASIPv6)
	[[ ${CHOST} == *-solaris2.11 ]] && append-cppflags -DHAS_PAD_MUTEX
	if [[ ${CHOST} == *-darwin* ]] ; then
		# make sys/proc_info.h available in ${T} because of LSOF_INCLUDE
		# dummy location -- Darwin needs this for a Configure check to
		# succeed
		if [[ -e /usr/include/sys/proc_info.h ]] ; then
			mkdir -p "${T}"/sys || die
			( cd "${T}"/sys && ln -s /usr/include/sys/proc_info.h ) || die
		fi
	fi

	export LSOF_CFGL="${CFLAGS} ${LDFLAGS} \
		$(use rpc && $(tc-getPKG_CONFIG) libtirpc --libs)"

	# Set LSOF_INCLUDE to a dummy location so the script doesn't poke
	# around in it and mix /usr/include paths with cross-compile/etc.
	touch .neverInv
	LINUX_HASSELINUX=$(usex selinux y n) \
	LSOF_INCLUDE=${T} \
	LSOF_CC=$(tc-getCC) \
	LSOF_AR="$(tc-getAR) rc" \
	LSOF_RANLIB=$(tc-getRANLIB) \
	LSOF_CFGF="${CFLAGS} ${CPPFLAGS}" \
	./Configure -n $(target) || die
}

src_compile() {
	emake DEBUG="" all
}

src_install() {
	dobin lsof

	if use examples ; then
		insinto /usr/share/lsof/scripts
		doins scripts/*
	fi

	doman lsof.8
	dodoc 00*
}

pkg_postinst() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		einfo "Note: to use lsof on Solaris you need read permissions on"
		einfo "/dev/kmem, i.e. you need to be root, or to be in the group sys"
	elif [[ ${CHOST} == *-aix* ]] ; then
		einfo "Note: to use lsof on AIX you need read permissions on /dev/mem and"
		einfo "/dev/kmem, i.e. you need to be root, or to be in the group system"
	fi
}
