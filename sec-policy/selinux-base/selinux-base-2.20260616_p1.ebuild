# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"

inherit python-any-r1

DESCRIPTION="Gentoo base policy for SELinux"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:SELinux"

if [[ "${PV}" = 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3
else
	MY_PV=$(ver_cut 1-2)
	SRC_URI="https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_${MY_PV/./_}/refpolicy-${MY_PV}.tar.bz2
		https://dev.gentoo.org/~perfinion/patches/selinux-base-policy/patchbundle-selinux-base-policy-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

S="${WORKDIR}/refpolicy"

LICENSE="GPL-2"
SLOT="0"
IUSE="
	doc +unknown-perms systemd +ubac +unconfined
	+selinux_policy_types_targeted +selinux_policy_types_strict +selinux_policy_types_mcs +selinux_policy_types_mls
"
REQUIRED_USE="
	|| ( selinux_policy_types_targeted selinux_policy_types_strict selinux_policy_types_mcs selinux_policy_types_mls )
"

RDEPEND=">=sys-apps/policycoreutils-2.8"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=sys-apps/checkpolicy-2.8
	sys-devel/m4
"

src_prepare() {
	if [[ "${PV}" != 9999* ]]; then
		cd "${WORKDIR}" || die
		einfo "Applying SELinux policy updates... "
		eapply -p0 "${WORKDIR}/0001-full-patch-against-stable-release.patch"
	fi

	cd "${S}" || die
	eapply_user

	emake bare
}

src_configure() {
	# Update the SELinux refpolicy capabilities based on the users' USE flags.
	if use unknown-perms; then
		sed -i -e '/^UNK_PERMS/s/deny/allow/' "${S}/build.conf" \
			|| die "Failed to allow Unknown Permissions Handling"
		sed -i -e '/^UNK_PERMS/s/deny/allow/' "${S}/Makefile" \
			|| die "Failed to allow Unknown Permissions Handling"
	fi

	if ! use ubac; then
		sed -i -e '/^UBAC/s/y/n/' "${S}/build.conf" \
			|| die "Failed to disable User Based Access Control"
	fi

	if use systemd; then
		sed -i -e '/^SYSTEMD/s/n/y/' "${S}/build.conf" \
			|| die "Failed to enable systemd"
	fi

	echo "DISTRO = gentoo" >> "${S}/build.conf" || die

	# Prepare initial configuration
	emake conf

	# Setup the policies based on the types delivered by the end user.
	# These types can be "targeted", "strict", "mcs" and "mls".
	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			cp -a "${S}" "${WORKDIR}/${type}" || die
			cd "${WORKDIR}/${type}" || die

			sed -i -e "/= module/d" "${WORKDIR}/${type}/policy/modules.conf" || die

			sed -i -e '/^QUIET/s/n/y/' -e "/^NAME/s/refpolicy/${type}/" \
				"${WORKDIR}/${type}/build.conf" || die "build.conf setup failed."

			if [[ "${type}" = "mls" || "${type}" = "mcs" ]]; then
				# MCS/MLS require additional settings
				sed -i -e "/^TYPE/s/standard/${type}/" "${WORKDIR}/${type}/build.conf" \
					|| die "failed to set type to mls"
			fi

			if [[ "${type}" = "targeted" ]]; then
				sed -i -e '/root/d' -e 's/user_u/unconfined_u/' \
					"${WORKDIR}/${type}/config/appconfig-standard/seusers" \
					|| die "targeted seusers setup failed."
			fi

			if [[ "${type}" != "targeted" && "${type}" != "strict" ]] && use unconfined; then
				sed -i -e '/root/d' -e 's/user_u/unconfined_u/' \
					"${WORKDIR}/${type}/config/appconfig-${type}/seusers" \
					|| die "policy seusers setup failed."
			fi
		fi
	done
}

src_compile() {
	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			cd "${WORKDIR}/${type}" || die
			emake base
			use doc && emake html
		fi
	done
}

src_install() {
	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			cd "${WORKDIR}/${type}" || die

			emake DESTDIR="${D}" install
			emake DESTDIR="${D}" install-headers

			echo "run_init_t" > "${D}/etc/selinux/${type}/contexts/run_init_type" || die

			echo "textrel_shlib_t" >> "${D}/etc/selinux/${type}/contexts/customizable_types" || die

			# libsemanage won't make this on its own
			keepdir "/etc/selinux/${type}/policy"

			if use doc; then
				docinto "${type}/html"
				dodoc -r doc/html/*;
			fi

			insinto /usr/share/selinux/devel;
			doins doc/policy.xml;
		fi
	done

	docinto /
	dodoc doc/Makefile.example doc/example.{te,fc,if}

	doman man/man8/*.8;

	insinto /etc/selinux
	doins "${FILESDIR}/config"

	insinto /usr/share/portage/config/sets
	doins "${FILESDIR}/selinux.conf"
}
