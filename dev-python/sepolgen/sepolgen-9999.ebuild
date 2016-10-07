# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit python-r1

MY_P="${P//_/-}"
MY_RELEASEDATE="20161006"

DESCRIPTION="SELinux policy generation library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/${MY_RELEASEDATE}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=sys-libs/libselinux-2.4[python]
		>=app-admin/setools-4.0[${PYTHON_USEDEP}]
		${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
	if [[ ${PV} != 9999 ]] ; then
		# If needed for live ebuilds please use /etc/portage/patches
		eapply "${FILESDIR}/0030-default-path-for-tests-also-needed-bug-467264.patch"
	fi

	eapply_user

	python_copy_sources
}

src_compile() {
	:
}

src_test() {
	if has_version sec-policy/selinux-base-policy; then
		invoke_sepolgen_test() {
			emake test
		}
		python_foreach_impl invoke_sepolgen_test
	else
		ewarn "Sepolgen requires sec-policy/selinux-base-policy to run tests."
	fi
}

src_install() {
	installation() {
		emake DESTDIR="${D}" PYTHONLIBDIR="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl installation

	# Create sepolgen.conf with different devel location definition
	if [[ -f /etc/selinux/config ]];
	then
		local selinuxtype=$(awk -F'=' '/^SELINUXTYPE/ {print $2}' /etc/selinux/config);
		mkdir -p "${D}"/etc/selinux || die "Failed to create selinux directory";
		echo "SELINUX_DEVEL_PATH=/usr/share/selinux/${selinuxtype}/include:/usr/share/selinux/${selinuxtype}" > "${D}"/etc/selinux/sepolgen.conf;
	else
		local selinuxtype="${POLICY_TYPES%% *}";
		if [[ -n "${selinuxtype}" ]];
		then
			echo "SELINUX_DEVEL_PATH=/usr/share/selinux/${selinuxtype}/include:/usr/share/selinux/${selinuxtype}" > "${D}"/etc/selinux/sepolgen.conf;
		else
			echo "SELINUX_DEVEL_PATH=/usr/share/selinux/strict/include:/usr/share/selinux/strict" > "${D}"/etc/selinux/sepolgen.conf;
		fi
	fi
}
