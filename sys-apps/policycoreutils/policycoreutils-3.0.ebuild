# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_6,3_7} )
PYTHON_REQ_USE="xml"

inherit multilib python-r1 toolchain-funcs bash-completion-r1

MY_P="${P//_/-}"

MY_RELEASEDATE="20191204"
EXTRAS_VER="1.36"
SEMNG_VER="${PV}"
SELNX_VER="${PV}"
SEPOL_VER="${PV}"

IUSE="audit dbus pam split-usr"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	SRC_URI="https://dev.gentoo.org/~perfinion/distfiles/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"
	S1="${WORKDIR}/${MY_P}/${PN}"
	S2="${WORKDIR}/policycoreutils-extra"
	S="${S1}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_RELEASEDATE}/${MY_P}.tar.gz
		https://dev.gentoo.org/~perfinion/distfiles/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~mips ~x86"
	S1="${WORKDIR}/${MY_P}"
	S2="${WORKDIR}/policycoreutils-extra"
	S="${S1}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libselinux-${SELNX_VER}:=[python,${PYTHON_USEDEP}]
	>=sys-libs/libcap-1.10-r10:=
	>=sys-libs/libsemanage-${SEMNG_VER}:=[python,${PYTHON_USEDEP}]
	sys-libs/libcap-ng:=
	>=sys-libs/libsepol-${SEPOL_VER}:=
	>=app-admin/setools-4.2.0[${PYTHON_USEDEP}]
	sys-devel/gettext
	dev-python/ipy[${PYTHON_USEDEP}]
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib:=
	)
	audit? ( >=sys-process/audit-1.5.1[python,${PYTHON_USEDEP}] )
	pam? ( sys-libs/pam:= )
	${PYTHON_DEPS}"

### libcgroup -> seunshare
### dbus -> restorecond

# pax-utils for scanelf used by rlpkg
RDEPEND="${DEPEND}
	app-misc/pax-utils"

PDEPEND="sys-apps/semodule-utils
	sys-apps/selinux-python"

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
		eapply "${FILESDIR}/policycoreutils-2.7-0001-newrole-not-suid.patch"
	fi

	# rlpkg is more useful than fixfiles
	sed -i -e '/^all/s/fixfiles//' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 1 failed"
	sed -i -e '/fixfiles/d' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 2 failed"

	eapply_user

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
			AUDITH="$(usex audit y n)" \
			PAMH="$(usex pam y n)" \
			INOTIFYH="$(usex dbus y n)" \
			SESANDBOX="n" \
			CC="$(tc-getCC)" \
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
			AUDIT_LOG_PRIVS="y" \
			AUDITH="$(usex audit y n)" \
			PAMH="$(usex pam y n)" \
			INOTIFYH="$(usex dbus y n)" \
			SESANDBOX="n" \
			CC="$(tc-getCC)" \
			LIBDIR="\$(PREFIX)/$(get_libdir)" \
			install
		python_optimize
	}

	installation-extras() {
		einfo "Installing policycoreutils-extra"
		emake -C "${BUILD_DIR}" \
			DESTDIR="${D}" \
			install
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
	use split-usr && dosym ../../sbin/setfiles /usr/sbin/setfiles

	bashcomp_alias setsebool getsebool

	# location for policy definitions
	dodir /var/lib/selinux
	keepdir /var/lib/selinux

	# Set version-specific scripts
	for pyscript in rlpkg; do
	  python_replicate_script "${ED}/usr/sbin/${pyscript}"
	done
}

pkg_postinst() {
	for POLICY_TYPE in ${POLICY_TYPES} ; do
		# There have been some changes to the policy store, rebuilding now.
		# https://marc.info/?l=selinux&m=143757277819717&w=2
		einfo "Rebuilding store ${POLICY_TYPE} (without re-loading)."
		semodule -s "${POLICY_TYPE}" -n -B || die "Failed to rebuild policy store ${POLICY_TYPE}"
	done
}
