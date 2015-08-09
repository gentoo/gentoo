# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Enlightenment's data types library (list, hash, etc) in C"

LICENSE="LGPL-2.1"
IUSE="altivec debug default-mempool cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 static-libs test valgrind"

MEMPOOLS=(
	@buddy
	+@chained-pool
	# Looks like ememoa is a dead project?
	#@ememoa-fixed
	#@ememoa-unknown
	@fixed-bitmap
	+@one-big
	@pass-through
)
IUSE_MEMPOOLS=${MEMPOOLS[@]/@/mempool-}
IUSE+=" ${IUSE_MEMPOOLS}"

RDEPEND="valgrind? ( dev-util/valgrind )"
#	mempool-ememoa-fixed? ( sys-libs/ememoa )
#	mempool-ememoa-unknown? ( sys-libs/ememoa )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-libs/check
		dev-libs/glib
		dev-util/lcov
	)"

src_configure() {
	# Evas benchmark is broken!
	E_ECONF=(
		$(use_enable altivec cpu-altivec)
		$(use_enable !debug amalgamation)
		$(use_enable debug stringshare-usage)
		$(use_enable debug assert)
		$(use debug || echo " --with-internal-maximum-log-level=2")
		$(use_enable default-mempool)
		$(use_enable doc)
		$(use_enable cpu_flags_x86_mmx cpu-mmx)
		$(use_enable cpu_flags_x86_sse cpu-sse)
		$(use_enable cpu_flags_x86_sse2 cpu-sse2)
		$(use test && echo " --disable-amalgamation")
		$(use_enable test e17)
		$(use_enable test tests)
		$(use_enable test benchmark)
		$(use test && echo " --with-internal-maximum-log-level=6")
		$(use_enable valgrind)
		--enable-magic-debug
		--enable-safety-checks
	)

	#if use mempool-ememoa-fixed || use mempool-ememoa-unknown ; then
	#	E_ECONF+=( --enable-ememoa )
	#else
		E_ECONF+=( --disable-ememoa )
	#fi

	local m mempool_arg='static'
	if use debug ; then
		mempool_arg='yes'
	fi
	for m in ${IUSE_MEMPOOLS//+} ; do
		E_ECONF+=( $(use_enable ${m} ${m} ${mempool_argT}) )
	done

	enlightenment_src_configure
}
