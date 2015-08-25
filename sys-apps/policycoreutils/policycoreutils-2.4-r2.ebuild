# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="xml"

inherit multilib python-r1 toolchain-funcs eutils bash-completion-r1

MY_P="${P//_/-}"

MY_RELEASEDATE="20150202"
EXTRAS_VER="1.34"
SEMNG_VER="${PV}"
SELNX_VER="${PV}"
SEPOL_VER="${PV}"

IUSE="audit pam dbus"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	SRC_URI="https://dev.gentoo.org/~perfinion/distfiles/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"
	S1="${WORKDIR}/${MY_P}/${PN}"
	S2="${WORKDIR}/policycoreutils-extra"
	S="${S1}"
else
	SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/${MY_RELEASEDATE}/${MY_P}.tar.gz
		https://dev.gentoo.org/~perfinion/distfiles/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S1="${WORKDIR}/${MY_P}"
	S2="${WORKDIR}/policycoreutils-extra"
	S="${S1}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libselinux-${SELNX_VER}:=[python]
	>=sys-libs/glibc-2.4
	>=sys-libs/libcap-1.10-r10:=
	>=sys-libs/libsemanage-${SEMNG_VER}:=[python]
	sys-libs/libcap-ng:=
	>=sys-libs/libsepol-${SEPOL_VER}:=
	sys-devel/gettext
	dev-python/ipy[${PYTHON_USEDEP}]
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib:=
	)
	audit? ( >=sys-process/audit-1.5.1 )
	pam? ( sys-libs/pam:= )
	${PYTHON_DEPS}"

### libcgroup -> seunshare
### dbus -> restorecond

# pax-utils for scanelf used by rlpkg
RDEPEND="${DEPEND}
	dev-python/sepolgen
	app-misc/pax-utils
	!<sys-apps/openrc-0.14"

src_unpack() {
	# Override default one because we need the SRC_URI ones even in case of 9999 ebuilds
	default
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	S="${S1}"
	cd "${S}" || die "Failed to switch to ${S}"
	if [[ ${PV} != 9999 ]] ; then
		# If needed for live ebuilds please use /etc/portage/patches
		epatch "${FILESDIR}/0010-remove-sesandbox-support.patch"
		epatch "${FILESDIR}/0020-disable-autodetection-of-pam-and-audit.patch"
		epatch "${FILESDIR}/0030-make-inotify-check-use-flag-triggered.patch"
		epatch "${FILESDIR}/0040-reverse-access-check-in-run_init.patch"
		epatch "${FILESDIR}/0070-remove-symlink-attempt-fails-with-gentoo-sandbox-approach.patch"
		epatch "${FILESDIR}/0110-build-mcstrans-bug-472912.patch"
		epatch "${FILESDIR}/0120-build-failure-for-mcscolor-for-CONTEXT__CONTAINS.patch"
		epatch "${FILESDIR}/0130-Only-invoke-RPM-on-RPM-enabled-Linux-distributions-bug-534682.patch"
		epatch "${FILESDIR}/0140-Set-self.sename-to-sename-after-calling-semanage-bug-557370.patch"
	fi

	# rlpkg is more useful than fixfiles
	sed -i -e '/^all/s/fixfiles//' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 1 failed"
	sed -i -e '/fixfiles/d' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 2 failed"

	epatch_user

	sed -i 's/-Werror//g' "${S1}"/*/Makefile || die "Failed to remove Werror"

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
		emake -C "${BUILD_DIR}" DESTDIR="${D}" \
			AUDITH="$(usex audit)" \
			PAMH="$(usex pam)" \
			INOTIFYH="$(usex dbus)" \
			SESANDBOX="n" \
			AUDIT_LOG_PRIV="y" \
			PYLIBVER="${EPYTHON}" \
			LIBDIR="\$(PREFIX)/$(get_libdir)" \
			install
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
	rm -fR "${D}/etc/rc.d" || die

	# compatibility symlinks
	dosym /sbin/setfiles /usr/sbin/setfiles
	bashcomp_alias setsebool getsebool

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
	cp -dR "${S1}"/mcstrans/share/examples/* "${D}/usr/share/doc/${PF}/mcstrans/examples" || die
}

pkg_postinst() {
	# The selinux_gentoo init script is no longer needed with recent OpenRC
	elog "The selinux_gentoo init script has been removed in this version as it is not required after OpenRC 0.13."

	for POLICY_TYPE in ${POLICY_TYPES} ; do
		# There have been some changes to the policy store, rebuilding now.
		# https://marc.info/?l=selinux&m=143757277819717&w=2
		einfo "Rebuilding store ${POLICY_TYPE} (without re-loading)."
		semodule -s "${POLICY_TYPE}" -n -B || die "Failed to rebuild policy store ${POLICY_TYPE}"
	done
}
