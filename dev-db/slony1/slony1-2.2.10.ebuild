# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.6 {10..14} )
POSTGRES_USEDEP="server,threads"

inherit postgres-multi

IUSE="doc perl"

DESCRIPTION="A replication system for the PostgreSQL Database Management System"
HOMEPAGE="https://slony.info/"

MAJ_PV=$(ver_cut 1-2)
SRC_URI="https://slony.info/downloads/${MAJ_PV}/source/${P}.tar.bz2
	doc? ( https://slony.info/downloads/${MAJ_PV}/source/${P}-docs.tar.bz2 )
"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="${POSTGRES_DEP}
		perl? ( dev-perl/DBD-Pg )
"
RDEPEND=${DEPEND}

REQUIRE_USE="${POSTGRES_REQ_USE}"

# Testing requires a more complex setup than we benefit from being able
# to perform.
# https://slony.info/documentation/2.2/testing.html
RESTRICT="test"

src_unpack() {
	unpack ${P}.tar.bz2

	if use doc ; then
		# The docs tarball will unpack over the source directory. So, we
		# clear the adminguide directory now to make it easier to
		# install later.
		rm ${P}/doc/adminguide/* || die
		unpack ${P}-docs.tar.bz2
	fi
}

src_configure() {
	local slot_bin_dir="/usr/$(get_libdir)/postgresql-@PG_SLOT@/bin"
	use perl && myconf=" --with-perltools=\"${slot_bin_dir}\""
	postgres-multi_foreach econf ${myconf} \
						   --with-pgconfigdir="${slot_bin_dir}" \
						   --with-slonybindir="${slot_bin_dir}"
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install

	dodoc README SAMPLE TODO UPGRADING share/slon.conf-sample
	use doc && postgres-multi_forbest dodoc -r doc/adminguide

	newinitd "${FILESDIR}"/slony1.init slony1
	newconfd "${FILESDIR}"/slony1.conf slony1
}

pkg_postinst() {
	# Slony-I installs its executables into a directory that is
	# processed by the PostgreSQL eselect module. Call it here so that
	# the symlinks will be created.
	ebegin "Refreshing PostgreSQL $(postgresql-config show) symlinks"
	postgresql-config update
	eend $?
}
