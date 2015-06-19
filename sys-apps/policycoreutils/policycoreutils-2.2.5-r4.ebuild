# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/policycoreutils/policycoreutils-2.2.5-r4.ebuild,v 1.2 2014/05/10 12:54:21 swift Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit multilib python-r1 toolchain-funcs eutils

EXTRAS_VER="1.31"
SEMNG_VER="2.2"
SELNX_VER="2.2"
SEPOL_VER="2.2"

IUSE="audit pam dbus"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/20131030/${P}.tar.gz
http://dev.gentoo.org/~swift/patches/policycoreutils/patchbundle-${P}-gentoo-r1.tar.gz
	mirror://gentoo/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPS=">=sys-libs/libselinux-${SELNX_VER}[python]
	>=sys-libs/glibc-2.4
	>=sys-libs/libcap-1.10-r10
	>=sys-libs/libsemanage-${SEMNG_VER}[python]
	sys-libs/libcap-ng
	>=sys-libs/libsepol-${SEPOL_VER}
	sys-devel/gettext
	dev-python/ipy
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	audit? ( >=sys-process/audit-1.5.1 )
	pam? ( sys-libs/pam )
	${PYTHON_DEPS}"

### libcgroup -> seunshare
### dbus -> restorecond

# pax-utils for scanelf used by rlpkg
RDEPEND="${COMMON_DEPS}
	dev-python/sepolgen
	app-misc/pax-utils"

DEPEND="${COMMON_DEPS}"

S1="${WORKDIR}/${P}"
S2="${WORKDIR}/policycoreutils-extra"

src_prepare() {
	# rlpkg is more useful than fixfiles
	sed -i -e '/^all/s/fixfiles//' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 1 failed"
	sed -i -e '/fixfiles/d' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 2 failed"

	EPATCH_MULTI_MSG="Applying policycoreutils patches ... " \
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}/gentoo-patches" \
	EPATCH_FORCE="yes" \
	epatch

	epatch_user

	python_copy_sources
	# Our extra code is outside the regular directory, so set it to the extra
	# directory. We really should optimize this as it is ugly, but the extra
	# code is needed for Gentoo at the same time that policycoreutils is present
	# (so we cannot use an additional package for now).
	S="${S2}"
	python_copy_sources
}

src_compile() {
	local use_audit="n";
	local use_pam="n";
	local use_dbus="n";
	local use_sesandbox="n";

	use audit && use_audit="y";
	use pam && use_pam="y";
	use dbus && use_dbus="y";

	building() {
		emake -C "${BUILD_DIR}" AUDIT_LOG_PRIVS="y" AUDITH="${use_audit}" PAMH="${use_pam}" INOTIFYH="${use_dbus}" SESANDBOX="${use_sesandbox}" CC="$(tc-getCC)" PYLIBVER="${EPYTHON}" || die
	}
	S="${S1}" # Regular policycoreutils
	python_foreach_impl building
	S="${S2}" # Extra set
	python_foreach_impl building
}

src_install() {
	local use_audit="n";
	local use_pam="n";
	local use_dbus="n";
	local use_sesandbox="n";

	use audit && use_audit="y";
	use pam && use_pam="y";
	use dbus && use_dbus="y";

	# Python scripts are present in many places. There are no extension modules.
	installation-policycoreutils() {
		einfo "Installing policycoreutils"
		emake -C "${BUILD_DIR}" DESTDIR="${D}" AUDITH="${use_audit}" PAMH="${use_pam}" INOTIFYH="${use_dbus}" SESANDBOX="${use_sesandbox}" AUDIT_LOG_PRIV="y" PYLIBVER="${EPYTHON}" install || return 1
	}

	installation-extras() {
		einfo "Installing policycoreutils-extra"
		emake -C "${BUILD_DIR}" DESTDIR="${D}" INOTIFYH="${use_dbus}" SHLIBDIR="${D}$(get_libdir)/rc" install || return 1
	}

	S="${S1}" # policycoreutils
	python_foreach_impl installation-policycoreutils
	S="${S2}" # extras
	python_foreach_impl installation-extras
	S="${S1}" # back for later

	# remove redhat-style init script
	rm -fR "${D}/etc/rc.d"

	# compatibility symlinks
	dosym /sbin/setfiles /usr/sbin/setfiles
	dosym /$(get_libdir)/rc/runscript_selinux.so /$(get_libdir)/rcscripts/runscript_selinux.so

	# location for permissive definitions
	dodir /var/lib/selinux
	keepdir /var/lib/selinux

	# Set version-specific scripts
	for pyscript in audit2allow sepolgen-ifgen sepolicy chcat; do
	  python_replicate_script "${ED}/usr/bin/${pyscript}"
	done
	for pyscript in semanage rlpkg; do
	  python_replicate_script "${ED}/usr/sbin/${pyscript}"
	done

	dodir /usr/share/doc/${PF}/mcstrans/examples
	cp -dR "${S1}"/mcstrans/share/examples/* "${D}/usr/share/doc/${PF}/mcstrans/examples"
}

pkg_postinst() {
	elog "Previous versions of policycoreutils optionally installed sesandbox support."
	elog "However, due to the possible unsafe state of seunshare (CVE-2014-3215) and the"
	elog "fact that sesandbox (called 'sandbox' upstream but collides with Portage sandbox)"
	elog "has not been supported in Gentoo for a while (for one, our policies do not provide"
	elog "sandboxing support) we have discontinued providing the sandbox related files."
}
