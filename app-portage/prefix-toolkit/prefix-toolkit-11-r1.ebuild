# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utilities for users of Gentoo Prefix"
HOMEPAGE="https://prefix.gentoo.org/"
SRC_URI="https://gitweb.gentoo.org/proj/prefix/prefix-toolkit.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"

[[ ${PV} == 9999 ]] ||
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="
	>sys-apps/portage-2.3.62
"
# In prefix-stack, these dependencies actually are the @system set,
# as we rely on the base prefix anyway for package management,
# which should have a proper @system set.
# Strictly speaking, only baselayout and gcc-config are necessary, but
# it is easier for now to install elt-patches, gentoo-functions and
# gnuconfig as well, instead of fixing all uses that expect them in
# EPREFIX rather than BROOT.
# See also: pkg_preinst
RDEPEND="${DEPEND}
	prefix-stack? (
		sys-devel/gcc-config
		app-portage/elt-patches
		sys-apps/gentoo-functions
		sys-devel/gnuconfig
	)
"

src_unpack() {
	default

	if use prefix-stack ; then
		local editor pager
		for editor in "${EDITOR}" {"${EPREFIX}","${BROOT}"}/bin/nano
		do
			[[ -x ${editor} ]] || continue
		done
		for pager in "${PAGER}" {"${EPREFIX}","${BROOT}"}/usr/bin/less
		do
			[[ -x ${pager} ]] || continue
		done
		printf '%s\n' "EDITOR=\"${editor}\"" "PAGER=\"${pager}\"" > 000fallback
	fi
}

my_prefixify() {
	local ebash eenv
	if use prefix-stack ; then
		ebash="${BROOT}/bin/bash"
		eenv="${BROOT}/usr/bin/env"
	else
		ebash="${EPREFIX}/bin/bash"
		eenv="${EPREFIX}/usr/bin/env"
	fi

	# the @=@ prevents repoman from believing we set readonly vars
	sed -e "s,@GENTOO_PORTAGE_BPREFIX@,${BROOT},g" \
		-e "s,@GENTOO_PORTAGE_EPREFIX@,${EPREFIX},g" \
		-e "s,@GENTOO_PORTAGE_CHOST@,${CHOST},g" \
		-e "s,@GENTOO_PORTAGE_EBASH@,${ebash},g" \
		-e "s,@GENTOO_PORTAGE_EENV@,${eenv},g" \
		-e "s,@=@,=,g" \
		-i "$@" || die
}

src_configure() {
	# do not eprefixify during unpack, to allow userpatches to apply
	my_prefixify *
}

src_install-prefix-stack-ccwrap() {
	# install toolchain wrapper.
	local wrapperdir=/usr/${CHOST}/gcc-bin/${CHOST}-${PN}/${PV}
	local wrappercfg=${CHOST}-${P}

	exeinto $wrapperdir
	doexe prefix-stack-ccwrap

	local cc
	for cc in \
		gcc \
		g++ \
		cpp \
		c++ \
		windres \
	; do
		dosym prefix-stack-ccwrap $wrapperdir/${CHOST}-${cc}
		dosym ${CHOST}-${cc} $wrapperdir/${cc}
	done

	# LDPATH is required to keep gcc-config happy :(
	cat > ./${wrappercfg} <<-EOF
		GCC_PATH="${EPREFIX}$wrapperdir"
		LDPATH="${EPREFIX}$wrapperdir"
		EOF

	insinto /etc/env.d/gcc
	doins ./${wrappercfg}
}

src_install() {
	if use prefix-stack; then
		src_install-prefix-stack-ccwrap
		insinto /etc
		doins prefix-stack.bash_login
		insinto /etc/bash
		newins prefix-stack.bashrc bashrc
		newenvd prefix-stack.envd.99stack 99stack
		doenvd 000fallback
		keepdir /usr/share/aclocal
	else
		dobin prefix-stack-setup
	fi
	if use prefix; then
		exeinto /
		doexe startprefix
	fi
}

pkg_preinst() {
	use prefix-stack || return 0
	ebegin "Purging @system package set for prefix stack"
	# In prefix stack we empty out the @system set defined via make.profile,
	# as we may be using some normal profile, but that @system set applies
	# to the base prefix only.
	# Instead, we only put ourselve into the @system set, and have additional
	# @system packages in our RDEPEND.
	my_lsprofile() {
		(
			cd -P "${1:-.}" || exit 1
			[[ -r ./parent ]] &&
				for p in $(<parent)
				do
					my_lsprofile "${p}" || exit 1
				done
			pwd -P
		)
	}
	local systemset="/etc/portage/profile/packages"
	dodir "${systemset%/*}"
	[[ -s ${EROOT}${systemset} ]] &&
		grep -v "# maintained by ${PN}" \
			"${EROOT}${systemset}" \
			> "${ED}${systemset}"
	local p
	for p in $(my_lsprofile "${EPREFIX}"/etc/portage/make.profile)
	do
		[[ -s ${p}/${systemset##*/} ]] || continue
		awk '/^[ \t]*[^-#]/{print "-" $1 " # maintained by '"${PN}-${PVR}"'"}' \
			< "${p}"/packages || die
	done | sort -u >> "${ED}${systemset}"
	[[ ${PIPESTATUS[@]} == "0 0" ]] || die "failed to collect for ${systemset}"
	echo "*${CATEGORY}/${PN} # maintained by ${PN}-${PVR}" >> "${ED}${systemset}" || die
	eend $?
}

pkg_postinst() {
	use prefix-stack || return 0
	[[ -x ${EROOT}/usr/bin/gcc-config ]] || return 0
	"${EROOT}"/usr/bin/gcc-config ${CHOST}-${P}
}
