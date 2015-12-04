# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

MY_PV=${PV/_/-}
MY_P=${PN}-${PV/_/-}

if [[ $PV == *9999 ]]; then
	KEYWORDS=""
	EGIT_REPO_URI="git://xenbits.xen.org/${PN}.git"
	live_eclass="git-2"
else
	KEYWORDS="~amd64 ~arm ~arm64 -x86"
	UPSTREAM_VER=0
	SECURITY_VER=
	GENTOO_VER=

	[[ -n ${UPSTREAM_VER} ]] && \
		UPSTREAM_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${P}-upstream-patches-${UPSTREAM_VER}.tar.xz"
	[[ -n ${SECURITY_VER} ]] && \
		SECURITY_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${PN}-security-patches-${SECURITY_VER}.tar.xz"
	[[ -n ${GENTOO_VER} ]] && \
		GENTOO_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${PN}-gentoo-patches-${GENTOO_VER}.tar.xz"
	SRC_URI="http://bits.xensource.com/oss-xen/release/${MY_PV}/${MY_P}.tar.gz
		${UPSTREAM_PATCHSET_URI}
		${SECURITY_PATCHSET_URI}
		${GENTOO_PATCHSET_URI}
		https://dev.gentoo.org/~idella4/distfiles/${PN}-security-patches.tar.gz"
fi

inherit mount-boot flag-o-matic python-any-r1 toolchain-funcs eutils ${live_eclass}

DESCRIPTION="The Xen virtual machine monitor"
HOMEPAGE="http://xen.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug efi flask xsm"

DEPEND="${PYTHON_DEPS}
	efi? ( >=sys-devel/binutils-2.22[multitarget] )
	!efi? ( >=sys-devel/binutils-2.22 )"
RDEPEND=""
PDEPEND="~app-emulation/xen-tools-${PV}"

RESTRICT="test"

# Approved by QA team in bug #144032
QA_WX_LOAD="boot/xen-syms-${PV}"

REQUIRED_USE="flask? ( xsm )
	arm? ( debug )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-any-r1_pkg_setup
	if [[ -z ${XEN_TARGET_ARCH} ]]; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64; then
			export XEN_TARGET_ARCH="x86_64"
		elif use arm; then
			export XEN_TARGET_ARCH="arm32"
		elif use arm64; then
			export XEN_TARGET_ARCH="arm64"
		else
			die "Unsupported architecture!"
		fi
	fi

	if use flask ; then
		export "XSM_ENABLE=y"
		export "FLASK_ENABLE=y"
	elif use xsm ; then
		export "XSM_ENABLE=y"
	fi
}

src_prepare() {
	# Upstream's patchset
	if [[ -n ${UPSTREAM_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		EPATCH_OPTS="-p1" \
			epatch "${WORKDIR}"/patches-upstream
	fi

	if [[ -n ${SECURITY_VER} ]]; then
		einfo "Try to apply Xen Security patcheset"
		source "${WORKDIR}"/patches-security/${PV}.conf
		# apply main xen patches
		for i in ${XEN_SECURITY_MAIN}; do
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
				epatch "${WORKDIR}"/patches-security/xen/$i
		done
	fi
	epatch "${WORKDIR}"/xsa156.patch

	# Gentoo's patchset
	if [[ -n ${GENTOO_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
			epatch "${WORKDIR}"/patches-gentoo
	fi

	epatch "${FILESDIR}"/${PN}-4.6-efi.patch

	# Drop .config
	sed -e '/-include $(XEN_ROOT)\/.config/d' -i Config.mk || die "Couldn't	drop"

	if use efi; then
		export EFI_VENDOR="gentoo"
		export EFI_MOUNTPOINT="boot"
	fi

	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \; || die "failed to re-set custom-cflags"
	fi

	# remove -Werror for gcc-4.6's sake
	find "${S}" -name 'Makefile*' -o -name '*.mk' -o -name 'common.make' | \
		xargs sed -i 's/ *-Werror */ /'
	# not strictly necessary to fix this
	sed -i 's/, "-Werror"//' "${S}/tools/python/setup.py" || die "failed to re-set setup.py"

	epatch_user
}

src_configure() {
	use arm && myopt="${myopt} CONFIG_EARLY_PRINTK=sun7i"

	use debug && myopt="${myopt} debug=y"

	if use custom-cflags; then
		filter-flags -fPIE -fstack-protector
		replace-flags -O3 -O2
	else
		unset CFLAGS
		unset LDFLAGS
		unset ASFLAGS
	fi
}

src_compile() {
	# Send raw LDFLAGS so that --as-needed works
	emake V=1 CC="$(tc-getCC)" LDFLAGS="$(raw-ldflags)" LD="$(tc-getLD)" -C xen ${myopt}
}

src_install() {
	local myopt
	use debug && myopt="${myopt} debug=y"

	# The 'make install' doesn't 'mkdir -p' the subdirs
	if use efi; then
		mkdir -p "${D}"${EFI_MOUNTPOINT}/efi/${EFI_VENDOR} || die
	fi

	emake LDFLAGS="$(raw-ldflags)" DESTDIR="${D}" -C xen ${myopt} install
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " https://wiki.gentoo.org/wiki/Xen"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"

	use efi && einfo "The efi executable is installed in boot/efi/gentoo"
}
