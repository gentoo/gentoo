# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit multilib python-r1 toolchain-funcs eutils

MY_P="${P//_/-}"

EXTRAS_VER="1.33"
SEMNG_VER="${PV}"
SELNX_VER="${PV}"
SEPOL_VER="${PV}"

IUSE="audit pam dbus"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"
SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20150202/${MY_P}.tar.gz
	mirror://gentoo/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=sys-libs/libselinux-${SELNX_VER}[python]
	>=sys-libs/glibc-2.4
	>=sys-libs/libcap-1.10-r10
	>=sys-libs/libsemanage-${SEMNG_VER}[python]
	sys-libs/libcap-ng
	>=sys-libs/libsepol-${SEPOL_VER}
	sys-devel/gettext
	dev-python/ipy[${PYTHON_USEDEP}]
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
RDEPEND="${DEPEND}
	dev-python/sepolgen
	app-misc/pax-utils"

S="${WORKDIR}/${MY_P}"
S1="${WORKDIR}/${MY_P}"
S2="${WORKDIR}/policycoreutils-extra"

src_prepare() {
	epatch "${FILESDIR}/0010-remove-sesandbox-support.patch"
	epatch "${FILESDIR}/0020-disable-autodetection-of-pam-and-audit.patch"
	epatch "${FILESDIR}/0030-make-inotify-check-use-flag-triggered.patch"
	epatch "${FILESDIR}/0040-reverse-access-check-in-run_init.patch"
	epatch "${FILESDIR}/0070-remove-symlink-attempt-fails-with-gentoo-sandbox-approach.patch"
	epatch "${FILESDIR}/0110-build-mcstrans-bug-472912.patch"
	epatch "${FILESDIR}/0120-build-failure-for-mcscolor-for-CONTEXT__CONTAINS.patch"

	# rlpkg is more useful than fixfiles
	sed -i -e '/^all/s/fixfiles//' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 1 failed"
	sed -i -e '/fixfiles/d' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 2 failed"

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
	building() {
		emake -C "${BUILD_DIR}" \
			AUDIT_LOG_PRIVS="y" \
			AUDITH="$(usex audit)" \
			PAMH="$(usex pam)" \
			INOTIFYH="$(usex dbus)" \
			SESANDBOX="n" \
			CC="$(tc-getCC)" \
			PYLIBVER="${EPYTHON}" \
			LIBDIR="\$(PREFIX)/$(get_libdir)"
	}
	S="${S1}" # Regular policycoreutils
	python_foreach_impl building
	S="${S2}" # Extra set
	python_foreach_impl building
}

src_install() {
	# Python scripts are present in many places. There are no extension modules.
	installation-policycoreutils() {
		einfo "Installing policycoreutils"
		emake -C "${BUILD_DIR}" DESTDIR="${D}" AUDITH="$(usex audit)" PAMH="$(usex pam)" INOTIFYH="$(usex dbus)" SESANDBOX="n" AUDIT_LOG_PRIV="y" PYLIBVER="${EPYTHON}" install
		python_optimize
	}

	installation-extras() {
		einfo "Installing policycoreutils-extra"
		emake -C "${BUILD_DIR}" DESTDIR="${D}" INOTIFYH="$(usex dbus)" SHLIBDIR="${D}$(get_libdir)/rc" install
		python_optimize
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

	# location for policy definitions
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
	# The selinux_gentoo init script is no longer needed with recent OpenRC
	elog "The selinux_gentoo init script will be removed in future versions since it is not needed with OpenRC 0.13."
}
