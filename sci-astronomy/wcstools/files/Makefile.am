SUBDIRS = libwcs
INCLUDES = -I$(top_srcdir)/libwcs

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = wcstools.pc

bin_SCRIPTS = wcstools

EXTRA_DIST = wcstools COPYING Readme NEWS Programs

bin_PROGRAMS = \
	cphead delwcs delhead edhead fixpix gethead i2f imcat imhead immatch \
	imrot imsize imstar imwcs scat sethead addpix getpix setpix sky2xy \
	keyhead skycoor subpix xy2sky wcshead conpix gettab newfits getfits \
	imstack imextract sumpix wcsremap getcol wcsgetdate imfill imsmooth imresize \
	fileroot filename filext char2sp sp2char wcscrlf isnum isrange isfits \
	isfile simpos bincat

# these ones don't need libwcs
wcscrlf_SOURCES = crlf.c
filename_SOURCES = filename.c
filedir_SOURCES = filedir.c
fileroot_SOURCES = fileroot.c
filext_SOURCES = filext.c
isrange_SOURCES = isrange.c

LDADD = $(top_builddir)/libwcs/libwcstools.la

bincat_SOURCES = bincat.c
getcol_SOURCES = getcol.c
wcsgetdate_SOURCES = getdate.c
gethead_SOURCES = gethead.c
getfits_SOURCES = getfits.c
getpix_SOURCES = getpix.c
gettab_SOURCES = gettab.c
imcat_SOURCES = imcat.c
imsize_SOURCES = imsize.c
imstar_SOURCES = imstar.c
imwcs_SOURCES = imwcs.c
immatch_SOURCES = immatch.c
scat_SOURCES = scat.c
setpix_SOURCES = setpix.c
skycoor_SOURCES = skycoor.c
sumpix_SOURCES = sumpix.c
xy2sky_SOURCES = xy2sky.c
simpos_SOURCES = simpos.c

addpix_SOURCES = addpix.c
char2sp_SOURCES = char2sp.c
conpix_SOURCES = conpix.c
cphead_SOURCES = cphead.c
delwcs_SOURCES = delwcs.c
delhead_SOURCES = delhead.c
edhead_SOURCES = edhead.c
fixpix_SOURCES = fixpix.c
i2f_SOURCES = i2f.c
imfill_SOURCES = imfill.c
imresize_SOURCES = imresize.c
imsmooth_SOURCES = imsmooth.c
imhead_SOURCES = imhead.c
imrot_SOURCES = imrot.c
imstack_SOURCES = imstack.c
imextract_SOURCES = imextract.c
isfile_SOURCES = isfile.c
isnum_SOURCES = isnum.c
keyhead_SOURCES = keyhead.c
newfits_SOURCES = newfits.c
wcsremap_SOURCES = remap.c
sethead_SOURCES = sethead.c
sky2xy_SOURCES = sky2xy.c
sp2char_SOURCES = sp2char.c
subpix_SOURCES = subpix.c
wcshead_SOURCES = wcshead.c
