# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib mount-boot flag-o-matic python-any-r1 toolchain-funcs

MY_PV=${PV/_/-}
MY_P=${PN}-${PV/_/-}

if [[ $PV == *9999 ]]; then
	inherit git-r3
	KEYWORDS="amd64"
	EGIT_REPO_URI="git://xenbits.xen.org/xen.git"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm -x86"
	UPSTREAM_VER=0
	SECURITY_VER=26
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
		${GENTOO_PATCHSET_URI}"
fi

DESCRIPTION="The Xen virtual machine monitor"
HOMEPAGE="http://xen.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug efi flask"

DEPEND="${PYTHON_DEPS}
	efi? ( >=sys-devel/binutils-2.22[multitarget] )
	!efi? ( >=sys-devel/binutils-2.22 )"
RDEPEND=""
PDEPEND="~app-emulation/xen-tools-${PV}"

# no tests are available for the hypervisor
# prevent the silliness of /usr/lib/debug/usr/lib/debug files
# prevent stripping of the debug info from the /usr/lib/debug/xen-syms
RESTRICT="test splitdebug strip"

# Approved by QA team in bug #144032
QA_WX_LOAD="boot/xen-syms-${PV}"

REQUIRED_USE="arm? ( debug )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-any-r1_pkg_setup
	if [[ -z ${XEN_TARGET_ARCH} ]]; then
		if use amd64; then
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

	# Security patchset
	if [[ -n ${SECURITY_VER} ]]; then
	einfo "Try to apply Xen Security patch set"
		# apply main xen patches
		# Two parallel systems, both work side by side
		# Over time they may concdense into one. This will suffice for now
		EPATCH_SUFFIX="patch"
		EPATCH_FORCE="yes"

		source "${WORKDIR}"/patches-security/${PV}.conf

		for i in ${XEN_SECURITY_MAIN}; do
			epatch "${WORKDIR}"/patches-security/xen/$i
		done
	fi

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

	# Bug #575868 converted to a sed statement, typo of one char
	sed -e "s:granter’s:granter's:" -i xen/include/public/grant_table.h || die

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

	# make install likes to throw in some extra EFI bits if it built
	use efi || rm -rf "${D}/usr/$(get_libdir)/efi"
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " https://wiki.gentoo.org/wiki/Xen"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"

	use efi && einfo "The efi executable is installed in boot/efi/gentoo"

	elog "You can optionally block the installation of /boot/xen-syms by an entry"
	elog "in folder /etc/portage/env using the portage's feature INSTALL_MASK"
	elog "e.g. echo ${msg} > /etc/portage/env/xen.conf"
}
