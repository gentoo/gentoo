# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-base/selinux-base-9999.ebuild,v 1.18 2015/04/21 10:34:30 perfinion Exp $
EAPI="5"

inherit eutils

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-git://anongit.gentoo.org/proj/hardened-refpolicy.git https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3

	KEYWORDS=""
else
	SRC_URI="https://raw.githubusercontent.com/wiki/TresysTechnology/refpolicy/files/refpolicy-${PV}.tar.bz2
			http://dev.gentoo.org/~swift/patches/selinux-base-policy/patchbundle-selinux-base-policy-${PVR}.tar.bz2"

	KEYWORDS="~amd64 ~x86"
fi

IUSE="+peer_perms +open_perms +ubac +unconfined doc"

DESCRIPTION="Gentoo base policy for SELinux"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/selinux/"
LICENSE="GPL-2"
SLOT="0"

RDEPEND=">=sys-apps/policycoreutils-2.3
	virtual/udev
	!<=sec-policy/selinux-base-policy-2.20120725"
DEPEND="${RDEPEND}
	sys-devel/m4
	>=sys-apps/checkpolicy-2.3"

S=${WORKDIR}/

#src_unpack() {
#	git-2_src_unpack
#}

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
			"${S}/refpolicy/policy/policy_capabilities"
	fi

	if ! use open_perms; then
		sed -i -e '/open_perms/d' \
			"${S}/refpolicy/policy/policy_capabilities"
	fi

	if ! use ubac; then
		sed -i -e '/^UBAC/s/y/n/' "${S}/refpolicy/build.conf" \
			|| die "Failed to disable User Based Access Control"
	fi

	echo "DISTRO = gentoo" >> "${S}/refpolicy/build.conf"

	# Prepare initial configuration
	cd "${S}/refpolicy";
	make conf || die "Make conf failed"

	# Setup the policies based on the types delivered by the end user.
	# These types can be "targeted", "strict", "mcs" and "mls".
	for i in ${POLICY_TYPES}; do
		cp -a "${S}/refpolicy" "${S}/${i}"
		cd "${S}/${i}";

		#cp "${FILESDIR}/modules-2.20120215.conf" "${S}/${i}/policy/modules.conf"
		sed -i -e "/= module/d" "${S}/${i}/policy/modules.conf"

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
		cd "${S}/${i}"
		emake base || die "${i} compile failed"
		if use doc; then
			make html || die
		fi
	done
}

src_install() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="targeted strict mls mcs"

	for i in ${POLICY_TYPES}; do
		cd "${S}/${i}"

		make DESTDIR="${D}" install \
			|| die "${i} install failed."

		make DESTDIR="${D}" install-headers \
			|| die "${i} headers install failed."

		echo "run_init_t" > "${D}/etc/selinux/${i}/contexts/run_init_type"

		echo "textrel_shlib_t" >> "${D}/etc/selinux/${i}/contexts/customizable_types"

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
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-2.20101213-r13"
	previous_less_than_r13=$?
}
