# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

inherit eutils

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-git://anongit.gentoo.org/proj/hardened-refpolicy.git https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3
else
	SRC_URI="https://raw.githubusercontent.com/wiki/TresysTechnology/refpolicy/files/refpolicy-${PV}.tar.bz2
			https://dev.gentoo.org/~swift/patches/selinux-base-policy/patchbundle-selinux-base-policy-${PVR}.tar.bz2"

	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

IUSE="doc +open_perms +peer_perms systemd +ubac +unconfined"

DESCRIPTION="Gentoo base policy for SELinux"
HOMEPAGE="https://www.gentoo.org/proj/en/hardened/selinux/"
LICENSE="GPL-2"
SLOT="0"

RDEPEND=">=sys-apps/policycoreutils-2.3
	virtual/udev"
DEPEND="${RDEPEND}
	sys-devel/m4
	>=sys-apps/checkpolicy-2.3"

S=${WORKDIR}/

src_prepare() {
	if [[ ${PV} != 9999* ]]; then
		# Apply the gentoo patches to the policy. These patches are only necessary
		# for base policies, or for interface changes on modules.
		EPATCH_MULTI_MSG="Applying SELinux policy updates ... " \
		EPATCH_SUFFIX="patch" \
		EPATCH_SOURCE="${WORKDIR}" \
		EPATCH_FORCE="yes" \
		epatch
	fi

	cd "${S}/refpolicy"
	make bare

	epatch_user
}

src_configure() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="targeted strict mls mcs"

	# Update the SELinux refpolicy capabilities based on the users' USE flags.

	if ! use peer_perms; then
		sed -i -e '/network_peer_controls/d' \
			"${S}/refpolicy/policy/policy_capabilities" || die
	fi

	if ! use open_perms; then
		sed -i -e '/open_perms/d' \
			"${S}/refpolicy/policy/policy_capabilities" || die
	fi

	if ! use ubac; then
		sed -i -e '/^UBAC/s/y/n/' "${S}/refpolicy/build.conf" \
			|| die "Failed to disable User Based Access Control"
	fi

	if use systemd; then
		sed -i -e '/^SYSTEMD/s/n/y/' "${S}/refpolicy/build.conf" \
			|| die "Failed to enable SystemD"
	fi

	echo "DISTRO = gentoo" >> "${S}/refpolicy/build.conf" || die

	# Prepare initial configuration
	cd "${S}/refpolicy" || die
	make conf || die "Make conf failed"

	# Setup the policies based on the types delivered by the end user.
	# These types can be "targeted", "strict", "mcs" and "mls".
	for i in ${POLICY_TYPES}; do
		cp -a "${S}/refpolicy" "${S}/${i}" || die
		cd "${S}/${i}" || die

		#cp "${FILESDIR}/modules-2.20120215.conf" "${S}/${i}/policy/modules.conf"
		sed -i -e "/= module/d" "${S}/${i}/policy/modules.conf" || die

		sed -i -e '/^QUIET/s/n/y/' -e "/^NAME/s/refpolicy/$i/" \
			"${S}/${i}/build.conf" || die "build.conf setup failed."

		if [[ "${i}" == "mls" ]] || [[ "${i}" == "mcs" ]];
		then
			# MCS/MLS require additional settings
			sed -i -e "/^TYPE/s/standard/${i}/" "${S}/${i}/build.conf" \
				|| die "failed to set type to mls"
		fi

		if [ "${i}" == "targeted" ]; then
			sed -i -e '/root/d' -e 's/user_u/unconfined_u/' \
			"${S}/${i}/config/appconfig-standard/seusers" \
			|| die "targeted seusers setup failed."
		fi

		if [ "${i}" != "targeted" ] && [ "${i}" != "strict" ] && use unconfined; then
			sed -i -e '/root/d' -e 's/user_u/unconfined_u/' \
			"${S}/${i}/config/appconfig-${i}/seusers" \
			|| die "policy seusers setup failed."
		fi
	done
}

src_compile() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="targeted strict mls mcs"

	for i in ${POLICY_TYPES}; do
		cd "${S}/${i}" || die
		emake base
		if use doc; then
			emake html
		fi
	done
}

src_install() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="targeted strict mls mcs"

	for i in ${POLICY_TYPES}; do
		cd "${S}/${i}" || die

		make DESTDIR="${D}" install \
			|| die "${i} install failed."

		make DESTDIR="${D}" install-headers \
			|| die "${i} headers install failed."

		echo "run_init_t" > "${D}/etc/selinux/${i}/contexts/run_init_type" || die

		echo "textrel_shlib_t" >> "${D}/etc/selinux/${i}/contexts/customizable_types" || die

		# libsemanage won't make this on its own
		keepdir "/etc/selinux/${i}/policy"

		if use doc; then
			dohtml doc/html/*;
		fi

		insinto /usr/share/selinux/devel;
		doins doc/policy.xml;

	done

	dodoc doc/Makefile.example doc/example.{te,fc,if}

	doman man/man8/*.8;

	insinto /etc/selinux
	doins "${FILESDIR}/config"

	insinto /usr/share/portage/config/sets
	doins "${FILESDIR}/selinux.conf"
}
