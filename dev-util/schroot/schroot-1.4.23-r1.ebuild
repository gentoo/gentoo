# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/schroot/schroot-1.4.23-r1.ebuild,v 1.1 2011/12/13 22:24:32 abcd Exp $

EAPI="4"

inherit autotools base pam versionator

MY_P=${PN}_${PV}

DESCRIPTION="Utility to execute commands in a chroot environment"
HOMEPAGE="http://packages.debian.org/source/sid/schroot"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}.orig.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="btrfs +dchroot debug doc lvm nls pam test"

COMMON_DEPEND="
	>=dev-libs/boost-1.42.0
	dev-libs/lockdev
	>=sys-apps/util-linux-2.16
	btrfs? ( >=sys-fs/btrfs-progs-0.19-r2 )
	lvm? ( sys-fs/lvm2 )
	pam? ( sys-libs/pam )
"

DEPEND="${COMMON_DEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.10.0 )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/debianutils
	dchroot? ( !sys-apps/dchroot )
	nls? ( virtual/libintl )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.7-tests.patch"
)

src_prepare() {
	base_src_prepare

	# Don't depend on cppunit unless we are testing
	use test || sed -i '/AM_PATH_CPPUNIT/d' configure.ac

	eautoreconf
}

src_configure() {
	root_tests=no
	use test && (( EUID == 0 )) && root_tests=yes
	econf \
		$(use_enable btrfs btrfs-snapshot) \
		$(use_enable doc doxygen) \
		$(use_enable dchroot) \
		$(use_enable dchroot dchroot-dsa) \
		$(use_enable debug) \
		$(use_enable lvm lvm-snapshot) \
		$(use_enable nls) \
		$(use_enable pam) \
		--enable-block-device \
		--enable-loopback \
		--enable-uuid \
		--enable-root-tests=$root_tests \
		--enable-shared \
		--disable-static \
		--localstatedir="${EPREFIX}"/var \
		--with-bash-completion-dir="${EPREFIX}"/usr/share/bash-completion
}

src_compile() {
	emake all $(usev doc)
}

src_test() {
	if [[ $root_tests == yes && $EUID -ne 0 ]]; then
		ewarn "Disabling tests because you are no longer root"
		return 0
	fi
	default
}

src_install() {
	default

	insinto /usr/share/doc/${PF}/contrib/setup.d
	doins contrib/setup.d/09fsck contrib/setup.d/10mount-ssh

	newinitd "${FILESDIR}"/schroot.initd schroot
	newconfd "${FILESDIR}"/schroot.confd schroot

	if use doc; then
		docinto html/sbuild
		dohtml doc/sbuild/html/*
		docinto html/schroot
		dohtml doc/schroot/html/*
	fi

	if use pam; then
		rm -f "${ED}"etc/pam.d/schroot
		pamd_mimic_system schroot auth account session
	fi

	# Remove *.la files
	find "${D}" -name "*.la" -exec rm {} + || die "removal of *.la files failed"
}

pkg_preinst() {
	if [[ ${REPLACING_VERSIONS} == 1.2* || ${REPLACING_VERSIONS} == 1.4.0* ]]; then
		einfo "Moving config files to new location..."
		mkdir "${EROOT}etc/schroot/default"
		mv_conffile etc/schroot/script-defaults etc/schroot/default/config
		mv_conffile etc/schroot/mount-defaults etc/schroot/default/fstab
		mv_conffile etc/schroot/copyfiles-defaults etc/schroot/default/copyfiles
		mv_conffile etc/schroot/nssdatabases-defaults etc/schroot/default/nssdatabases
	fi
}

mv_conffile() {
	local OLDFILE=${EROOT}$1
	local NEWFILE=${EROOT}$2

	# if the old file doesn't exist, or is a symlink, stop
	[[ -f ${OLDFILE} ]] || return 0
	[[ -L ${OLDFILE} ]] && return 0

	# if the new file already exists, then we have a problem...
	if [[ -e ${NEWFILE} ]]; then
		# but if they are the same, then don't worry about it
		if cmp -s "${OLDFILE}" "${NEWFILE}"; then
			rm -f "${OLDFILE}"
		else
			ewarn "${NEWFILE} already exists, not moving ${OLDFILE}"
		fi
	else
		mv "${OLDFILE}" "${NEWFILE}"
	fi

	local x y
	# now move all the unmerged config files as well
	for x in "${OLDFILE%/*}"/._cfg????_"${OLDFILE##*/}"; do
		[[ -f ${x} ]] || continue
		# /etc/schroot/._cfg0000_script-defaults -> /etc/schroot/default/._cfg0000_config
		y=${x##*/}
		y=${NEWFILE%*/}${y%${OLDFILE##*/}}${NEWFILE##*/}
		mv "${x}" "${y}"
	done
}

pkg_postinst() {
	local x
	if [[ ${REPLACING_VERSIONS} == 1.2* || ${REPLACING_VERSIONS} == 1.4.0* ]]; then
		for x in script:config mount:fstab copyfiles nssdatabases; do
			if [[ ! -e ${EROOT}etc/schroot/${x%:*}-defaults && -f ${EROOT}etc/schroot/default/${x#*:} ]]; then
				einfo "Creating compatibility symlink for ${x%:*}-defaults"
				ln -sf "default/${x#*:}" "${ROOT}etc/schroot/${x%:*}-defaults"
			fi
		done

		ewarn "Your config files have been moved to the new location in"
		ewarn "/etc/schroot/default. Compatibility symlinks have been installed in"
		ewarn "/etc/schroot, and may be removed if no running chroot refers to them."
	fi
}
