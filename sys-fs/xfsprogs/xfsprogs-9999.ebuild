# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd udev

DESCRIPTION="XFS filesystem utilities"
HOMEPAGE="https://xfs.wiki.kernel.org/ https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	inherit autotools # autoconf is used by the make configure
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git"
	EGIT_BRANCH="for-next"
else
	SRC_URI="https://www.kernel.org/pub/linux/utils/fs/xfs/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="icu libedit nls selinux static-libs"

RDEPEND="
	dev-libs/inih
	dev-libs/userspace-rcu:=
	>=sys-apps/util-linux-2.17.2
	icu? ( dev-libs/icu:= )
	libedit? ( dev-libs/libedit )
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-6.11
"

BDEPEND="
	${REGEN_BDEPEND}
	nls? ( sys-devel/gettext )
"
if [[ ${PV} == *9999 ]]; then
	BDEPEND+="
		dev-build/autoconf
		dev-build/automake
		dev-build/libtool
	"
fi

RDEPEND+=" selinux? ( sec-policy/selinux-xfs )"

src_prepare() {
	default

	# Fix doc dir
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in || die

	# Don't install compressed docs
	sed 's@\(CHANGES\)\.gz[[:space:]]@\1 @' -i doc/Makefile || die

	if [[ ${PV} == *9999 ]]; then
		prepare_release
		make configure
	fi
}

src_configure() {
	# include/builddefs.in will add FCFLAGS to CFLAGS which will
	# unnecessarily clutter CFLAGS (and fortran isn't used)
	unset FCFLAGS

	# If set in user env, this breaks configure
	unset PLATFORM

	export DEBUG=-DNDEBUG

	# Package is honoring CFLAGS; No need to use OPTIMIZER anymore.
	# However, we have to provide an empty value to avoid default
	# flags.
	export OPTIMIZER=" "

	# Avoid automagic on libdevmapper (bug #709694)
	export ac_cv_search_dm_task_create=no

	# bug 903611, 948468
	use elibc_musl && \
		append-flags -D_LARGEFILE64_SOURCE -DOVERRIDE_SYSTEM_STATX

	# Upstream does NOT support --disable-static anymore,
	# https://www.spinics.net/lists/linux-xfs/msg30185.html
	# https://www.spinics.net/lists/linux-xfs/msg30272.html
	local myconf=(
		--enable-static
		# Doesn't do anything beyond adding -flto (bug #930947).
		--disable-lto
		# The default value causes double 'lib'
		--localstatedir="${EPREFIX}/var"
		--with-crond-dir="${EPREFIX}/etc/cron.d"
		--with-systemd-unit-dir="$(systemd_get_systemunitdir)"
		--with-udev-rule-dir="$(get_udevdir)/rules.d"
		$(use_enable icu libicu)
		$(use_enable nls gettext)
		$(use_enable libedit editline)
	)

	econf "${myconf[@]}"
}

src_compile() {
	# -j1 for:
	# gmake[2]: *** No rule to make target '../libhandle/libhandle.la', needed by 'xfs_spaceman'.  Stop.
	emake V=1 -j1
}

src_install() {
	# XXX: There's a missing dep in the install-dev target, so split it
	emake DIST_ROOT="${ED}" HAVE_ZIPPED_MANPAGES=false install
	emake DIST_ROOT="${ED}" HAVE_ZIPPED_MANPAGES=false install-dev

	# Not actually used but --localstatedir causes this empty dir
	# to be installed.
	rmdir "${ED}"/var/lib/xfsprogs "${ED}"/var/lib || die

	if ! use static-libs; then
		rm "${ED}/usr/$(get_libdir)/libhandle.a" || die
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
}

prepare_release() { # updates the version number in several places

	# pass it to sed so it returns 1 when no replace occurred
	local RS=';tm;${x;/1/{x;q};x;q1};b;:m;x;s/.*/1/;x'

	parse_version() {
		local -n parsed_version="${1}" # modify the variable passed as reference
		parsed_version="$(grep -o -- \
			'^AC_INIT(\[xfsprogs\],\[[0-9]\+\.[0-9]\+\.[0-9]\+\],\[linux-xfs@vger.kernel.org\])$' \
			configure.ac || die)"

		parsed_version=$( echo "${parsed_version}" | ( sed -r \
			's/^AC_INIT\(\[xfsprogs\],\[([0-9]+).([0-9]+).([0-9]+)\],\[linux-xfs@vger\.kernel\.org\]\)$/\1.\2.9999/'"${RS}" \
			|| die ) )
	}

	isolate_updateversion_function() {
		# parses a function block from the upstream script
		local updateversion_function
		updateversion_function=$( sed -n \
			'/^update_version() {/,/^}$/p' release.sh || die )
		updateversion_function=$( echo "${updateversion_function}" \
			| ( sed -r 's/^update_version\(\) \{$//'"${RS}" || die ) )
		updateversion_function=$( echo "${updateversion_function}" \
			| ( sed -r 's/^\}$//'"${RS}" || die ) )
		echo "${updateversion_function}" > ./release_update_version.sh
		chmod +x release_update_version.sh
	}

	update_VERSION_file() {
		local version="$1"
		local version_file
		local version_major
		local version_minor
		local version_revision

		version_major=$( echo "${version}" | ( sed -r \
			's/^([0-9]+).([0-9]+).([0-9]+)$/\1/'"${RS}" || die ) )
		version_file+='PKG_MAJOR='"${version_major}"$'\n'

		version_minor=$( echo "${version}" | ( sed -r \
			's/^([0-9]+).([0-9]+).([0-9]+)$/\2/'"${RS}" || die ) )
		version_file+='PKG_MINOR='"${version_minor}"$'\n'

		local version_revision=$( echo "${version}" | ( sed -r \
			's/^([0-9]+).([0-9]+).([0-9]+)$/\3/'"${RS}" || die ) )
		version_file+='PKG_REVISION='"${version_revision}"$'\n'

		echo "${version_file}" > ./VERSION
	}

	local version
	parse_version version # pass version as reference

	isolate_updateversion_function

	update_VERSION_file "${version}"

	# replace editor with true to avoid manually editing the VERSION file
	EDITOR="true" version="${version}" ./release_update_version.sh
}
