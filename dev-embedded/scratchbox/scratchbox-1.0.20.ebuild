# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils user

SBOX_GROUP="sbox"

DESCRIPTION="A cross-compilation toolkit for embedded Linux application development"
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/hathor/tarball/scratchbox-core-${PV}-i386.tar.gz
	http://scratchbox.org/download/files/sbox-releases/hathor/tarball/scratchbox-libs-${PV}-i386.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Stripping BREAKS scratchbox, it runs in a chroot and is pre-stripped when needed (bug #296294)
RESTRICT="strip"

DEPEND=""
RDEPEND=""

TARGET_DIR="/opt/scratchbox"

S=${WORKDIR}/${PN}

src_install() {
	dodir ${TARGET_DIR}
	# doins doesn't work with symlinks, getting "file not found" with doins
	cp -pRP ./* "${D}/${TARGET_DIR}"
	ln -s opt/scratchbox "${D}/scratchbox"

	# scratchbox service loader
	newinitd "${FILESDIR}/scratchbox.rc" scratchbox || die "newinitd failed"

	# group already created
	echo ${SBOX_GROUP} > "${D}/${TARGET_DIR}/.run_me_first_done"
}

pkg_preinst() {
	einfo "Creating group sbox"
	enewgroup "${SBOX_GROUP}"
}

pkg_postinst() {
	"${TARGET_DIR}/sbin/sbox_configure" "no" ${SBOX_GROUP}

	elog
	elog "You can run:"
	elog "\"emerge --config =${CATEGORY}/${PF}\""
	elog "to setup scratchbox users"
	elog
	elog "For further documentation about how to setup"
	elog "scratchbox for your development needs have a look at"
	elog "http://scratchbox.org/documentation/user/scratchbox-1.0/"
	elog
	elog "Also note that when you reboot you should run:"
	elog "/etc/init.d/scratchbox start"
	elog "before trying to run scratchbox."
	elog "You can also add it to the default runlevel:"
	elog "rc-update add scratchbox default"
	elog
	elog "Type /opt/scratchbox/login to start scratchbox."
	elog
}

pkg_postrm() {
	elog
	elog "To remove all traces of scratchbox you will need to remove the file"
	elog "/etc/init.d/scratchbox. Don't forget to delete the sbox group."
	elog
}

pkg_config() {
	if [ `id -u` != "0" ]; then
		ewarn "Must be root to run this"
		die "not root"
	fi

	mkdir -p "${TARGET_DIR}/users"

	while true; do
		einfo "Existing users:"
		einfo $(ls "${TARGET_DIR}/users")
		echo

		einfo "Create new user (leaf empty to skip): "
		read newuser
		case "$newuser" in
			"")
				break;
				;;
			*)
				einfo "Note: users have to be in the '${SBOX_GROUP}' to be able to login into the scratchbox"
				"${TARGET_DIR}/sbin/sbox_adduser" ${newuser} || die "sbox_adduser failed"
				;;
		esac
	done

	einfo "Configuration finished. Make sure you run '/etc/init.d/scratchbox start' before logging in."
}
