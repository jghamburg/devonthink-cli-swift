/*
 * DEVONthink.m
 */

#include "DEVONthink.h"




/*
 * Standard Suite
 */

@implementation DEVONthinkApplication

typedef struct { NSString *name; FourCharCode code; } classForCode_t;
static const classForCode_t classForCodeData__[] = {
	{ @"DEVONthinkApplication", 'capp' },
	{ @"DEVONthinkWindow", 'cwin' },
	{ @"DEVONthinkAttachment", 'atts' },
	{ @"DEVONthinkRichText", 'ctxt' },
	{ @"DEVONthinkAttributeRun", 'catr' },
	{ @"DEVONthinkCharacter", 'cha ' },
	{ @"DEVONthinkParagraph", 'cpar' },
	{ @"DEVONthinkWord", 'cwor' },
	{ @"DEVONthinkDocumentWindow", 'cowi' },
	{ @"DEVONthinkMainWindow", 'brws' },
	{ @"DEVONthinkApplication", 'DTpa' },
	{ @"DEVONthinkChild", 'DTch' },
	{ @"DEVONthinkContent", 'DTcn' },
	{ @"DEVONthinkDatabase", 'DTkb' },
	{ @"DEVONthinkIncomingReference", 'DTic' },
	{ @"DEVONthinkIncomingWikiReference", 'DTwr' },
	{ @"DEVONthinkOutgoingReference", 'DToc' },
	{ @"DEVONthinkOutgoingWikiReference", 'DTow' },
	{ @"DEVONthinkParent", 'DTpr' },
	{ @"DEVONthinkRecord", 'DTrc' },
	{ @"DEVONthinkReminder", 'DTrm' },
	{ @"DEVONthinkSelectedRecord", 'DTsd' },
	{ @"DEVONthinkSmartParent", 'DTsx' },
	{ @"DEVONthinkTagGroup", 'DTta' },
	{ @"DEVONthinkTab", 'thtb' },
	{ @"DEVONthinkThinkWindow", 'thwi' },
	{ nil, 0 } 
};

- (NSDictionary *) classNamesForCodes
{
	static NSMutableDictionary *dict__;

	if (!dict__) @synchronized([self class]) {
	if (!dict__) {
		dict__ = [[NSMutableDictionary alloc] init];
		const classForCode_t *p;
		for (p = classForCodeData__; p->name != nil; ++p)
			[dict__ setObject:p->name forKey:[NSNumber numberWithUnsignedInt:p->code]];
	} }
	return dict__;
}

typedef struct { FourCharCode code; NSString *name; } codeForPropertyName_t;
static const codeForPropertyName_t codeForPropertyNameData__[] = {
	{ 'lwcp', @"copies" },
	{ 'lwcl', @"collating" },
	{ 'lwfp', @"startingPage" },
	{ 'lwlp', @"endingPage" },
	{ 'lwla', @"pagesAcross" },
	{ 'lwld', @"pagesDown" },
	{ 'lwqt', @"requestedPrintTime" },
	{ 'lweh', @"errorHandling" },
	{ 'faxn', @"faxNumber" },
	{ 'trpr', @"targetPrinter" },
	{ 'pnam', @"name" },
	{ 'pisf', @"frontmost" },
	{ 'vers', @"version" },
	{ 'pnam', @"name" },
	{ 'ID  ', @"id" },
	{ 'pidx', @"index" },
	{ 'pbnd', @"bounds" },
	{ 'hclb', @"closeable" },
	{ 'ismn', @"miniaturizable" },
	{ 'pmnd', @"miniaturized" },
	{ 'prsz', @"resizable" },
	{ 'pvis', @"visible" },
	{ 'iszm', @"zoomable" },
	{ 'pzum', @"zoomed" },
	{ 'atfn', @"fileName" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'atfn', @"fileName" },
	{ 'DAbo', @"baselineOffset" },
	{ 'DAbc', @"background" },
	{ 'DAfl', @"firstLineHeadIndent" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'DAhi', @"headIndent" },
	{ 'DAun', @"underlined" },
	{ 'DAls', @"lineSpacing" },
	{ 'DAlh', @"multipleLineHeight" },
	{ 'DAmx', @"maximumLineHeight" },
	{ 'DAmi', @"minimumLineHeight" },
	{ 'DAps', @"paragraphSpacing" },
	{ 'DAss', @"superscript" },
	{ 'DAti', @"tailIndent" },
	{ 'DNtc', @"textContent" },
	{ 'DAta', @"alignment" },
	{ 'pURL', @"URL" },
	{ 'DAbo', @"baselineOffset" },
	{ 'DAbc', @"background" },
	{ 'DAfl', @"firstLineHeadIndent" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'DAhi', @"headIndent" },
	{ 'DAun', @"underlined" },
	{ 'DAls', @"lineSpacing" },
	{ 'DAlh', @"multipleLineHeight" },
	{ 'DAmx', @"maximumLineHeight" },
	{ 'DAmi', @"minimumLineHeight" },
	{ 'DAps', @"paragraphSpacing" },
	{ 'DAss', @"superscript" },
	{ 'DAti', @"tailIndent" },
	{ 'DNtc', @"textContent" },
	{ 'DAta', @"alignment" },
	{ 'pURL', @"URL" },
	{ 'DAbo', @"baselineOffset" },
	{ 'DAbc', @"background" },
	{ 'DAfl', @"firstLineHeadIndent" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'DAhi', @"headIndent" },
	{ 'DAun', @"underlined" },
	{ 'DAls', @"lineSpacing" },
	{ 'DAlh', @"multipleLineHeight" },
	{ 'DAmx', @"maximumLineHeight" },
	{ 'DAmi', @"minimumLineHeight" },
	{ 'DAps', @"paragraphSpacing" },
	{ 'DAss', @"superscript" },
	{ 'DAti', @"tailIndent" },
	{ 'DNtc', @"textContent" },
	{ 'DAta', @"alignment" },
	{ 'pURL', @"URL" },
	{ 'DAbo', @"baselineOffset" },
	{ 'DAbc', @"background" },
	{ 'DAfl', @"firstLineHeadIndent" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'DAhi', @"headIndent" },
	{ 'DAun', @"underlined" },
	{ 'DAls', @"lineSpacing" },
	{ 'DAlh', @"multipleLineHeight" },
	{ 'DAmx', @"maximumLineHeight" },
	{ 'DAmi', @"minimumLineHeight" },
	{ 'DAps', @"paragraphSpacing" },
	{ 'DAss', @"superscript" },
	{ 'DAti', @"tailIndent" },
	{ 'DNtc', @"textContent" },
	{ 'DAta', @"alignment" },
	{ 'pURL', @"URL" },
	{ 'DAbo', @"baselineOffset" },
	{ 'DAbc', @"background" },
	{ 'DAfl', @"firstLineHeadIndent" },
	{ 'font', @"font" },
	{ 'ptsz', @"size" },
	{ 'colr', @"color" },
	{ 'DAhi', @"headIndent" },
	{ 'DAun', @"underlined" },
	{ 'DAls', @"lineSpacing" },
	{ 'DAlh', @"multipleLineHeight" },
	{ 'DAmx', @"maximumLineHeight" },
	{ 'DAmi', @"minimumLineHeight" },
	{ 'DAps', @"paragraphSpacing" },
	{ 'DAss', @"superscript" },
	{ 'DAti', @"tailIndent" },
	{ 'DNtc', @"textContent" },
	{ 'DAta', @"alignment" },
	{ 'pURL', @"URL" },
	{ 'DTdr', @"contentRecord" },
	{ 'DTru', @"searchResults" },
	{ 'DTro', @"root" },
	{ 'DTss', @"searchQuery" },
	{ 'DTsl', @"selection" },
	{ 'BTbn', @"batesNumber" },
	{ 'DTca', @"cancelledProgress" },
	{ 'DTci', @"currentChatEngine" },
	{ 'DTcd', @"currentChatModel" },
	{ 'DTcg', @"currentGroup" },
	{ 'DTcw', @"currentWorkspace" },
	{ 'DTcu', @"currentDatabase" },
	{ 'DTdr', @"contentRecord" },
	{ 'DTib', @"inbox" },
	{ 'DTig', @"incomingGroup" },
	{ 'DTln', @"labelNames" },
	{ 'DTlr', @"lastDownloadedResponse" },
	{ 'DTld', @"lastDownloadedURL" },
	{ 'DTid', @"preferredImportDestination" },
	{ 'DTrl', @"readingList" },
	{ 'DTsl', @"selection" },
	{ 'DTrg', @"strictDuplicateRecognition" },
	{ 'DTws', @"workspaces" },
	{ 'ID  ', @"id" },
	{ 'UUID', @"uuid" },
	{ 'DTas', @"annotationsGroup" },
	{ 'DTco', @"comment" },
	{ 'DTcg', @"currentGroup" },
	{ 'DTig', @"incomingGroup" },
	{ 'DTey', @"encrypted" },
	{ 'DTey', @"revisionProof" },
	{ 'DTry', @"readOnly" },
	{ 'DTsi', @"SpotlightIndexing" },
	{ 'DTvs', @"versioning" },
	{ 'pnam', @"name" },
	{ 'DTfe', @"filename" },
	{ 'ppth', @"path" },
	{ 'DTro', @"root" },
	{ 'DTts', @"tagsGroup" },
	{ 'DTtg', @"trashGroup" },
	{ 'DTvg', @"versionsGroup" },
	{ 'ID  ', @"id" },
	{ 'DTmt', @"MIMEType" },
	{ 'UUID', @"uuid" },
	{ 'DTad', @"additionDate" },
	{ 'DTal', @"aliases" },
	{ 'galt', @"altitude" },
	{ 'DTan', @"annotation" },
	{ 'DTna', @"annotationCount" },
	{ 'DTac', @"attachedScript" },
	{ 'DTnt', @"attachmentCount" },
	{ 'DTar', @"attributesChangeDate" },
	{ 'BTbn', @"batesNumber" },
	{ 'DTce', @"cells" },
	{ 'DTcc', @"characterCount" },
	{ 'colr', @"color" },
	{ 'DTcl', @"columns" },
	{ 'DTco', @"comment" },
	{ 'DTdi', @"contentHash" },
	{ 'DTcr', @"creationDate" },
	{ 'DTcm', @"customMetaData" },
	{ 'tdta', @"data" },
	{ 'DTkb', @"database" },
	{ 'ldt ', @"date" },
	{ 'Ddoi', @"digitalObjectIdentifier" },
	{ 'pdim', @"dimensions" },
	{ 'DTdm', @"documentAmount" },
	{ 'DTdd', @"documentDate" },
	{ 'Dadd', @"allDocumentDates" },
	{ 'DTpn', @"documentName" },
	{ 'DTdp', @"dpi" },
	{ 'DTdu', @"duplicates" },
	{ 'pdur', @"duration" },
	{ 'DTey', @"encrypted" },
	{ 'DTxi', @"excludeFromChat" },
	{ 'DTxc', @"excludeFromClassification" },
	{ 'DTxs', @"excludeFromSearch" },
	{ 'DTxa', @"excludeFromSeeAlso" },
	{ 'DTxt', @"excludeFromTagging" },
	{ 'DTxw', @"excludeFromWikiLinking" },
	{ 'DTfe', @"filename" },
	{ 'DTst', @"flag" },
	{ 'gloc', @"geolocation" },
	{ 'phit', @"height" },
	{ 'imaA', @"image" },
	{ 'DTix', @"indexed" },
	{ 'isbn', @"internationalStandardBookNumber" },
	{ 'DTiv', @"interval" },
	{ 'DTki', @"kind" },
	{ 'DTla', @"label" },
	{ 'lang', @"language" },
	{ 'glat', @"latitude" },
	{ 'DTlo', @"location" },
	{ 'DTlg', @"locationGroup" },
	{ 'DTlx', @"locationWithName" },
	{ 'DTlc', @"locking" },
	{ 'glon', @"longitude" },
	{ 'mkds', @"markdownSource" },
	{ 'mtdt', @"metaData" },
	{ 'DTmo', @"modificationDate" },
	{ 'pnam', @"name" },
	{ 'DTns', @"nameWithoutDate" },
	{ 'DTnw', @"nameWithoutExtension" },
	{ 'Dndd', @"newestDocumentDate" },
	{ 'DTnd', @"numberOfDuplicates" },
	{ 'DTnh', @"numberOfHits" },
	{ 'DTnr', @"numberOfReplicants" },
	{ 'Dodd', @"oldestDocumentDate" },
	{ 'onam', @"originalName" },
	{ 'DTon', @"openingDate" },
	{ 'DTpc', @"pageCount" },
	{ 'pgPD', @"paginatedPDF" },
	{ 'ppth', @"path" },
	{ 'DTpd', @"pending" },
	{ 'DTpl', @"plainText" },
	{ 'DTfn', @"proposedFilename" },
	{ 'DTrt', @"rating" },
	{ 'DTrp', @"recordType" },
	{ 'rURL', @"referenceURL" },
	{ 'DTrm', @"reminder" },
	{ 'ctxt', @"richText" },
	{ 'DTso', @"score" },
	{ 'ptsz', @"size" },
	{ 'conT', @"source" },
	{ 'DTtt', @"tagType" },
	{ 'tags', @"tags" },
	{ 'DTth', @"thumbnail" },
	{ 'DTuw', @"unlinkedWikiLinks" },
	{ 'DTur', @"unread" },
	{ 'pURL', @"URL" },
	{ 'DNav', @"webArchive" },
	{ 'pwid', @"width" },
	{ 'DTwc', @"wordCount" },
	{ 'DRal', @"alarm" },
	{ 'DRas', @"alarmString" },
	{ 'DRdw', @"dayOfWeek" },
	{ 'DRdu', @"dueDate" },
	{ 'DTiv', @"interval" },
	{ 'DRmc', @"masc" },
	{ 'DRsc', @"schedule" },
	{ 'DRnw', @"weekOfMonth" },
	{ 'DTqx', @"excludeSubgroups" },
	{ 'DTqh', @"highlightOccurrences" },
	{ 'DTqg', @"searchGroup" },
	{ 'DTqt', @"searchPredicates" },
	{ 'ID  ', @"id" },
	{ 'pPDF', @"PDF" },
	{ 'DNav', @"webArchive" },
	{ 'DTli', @"currentLine" },
	{ 'DTmf', @"currentMovieFrame" },
	{ 'DTti', @"currentTime" },
	{ 'DTpe', @"currentPage" },
	{ 'DTkb', @"database" },
	{ 'DTdr', @"contentRecord" },
	{ 'iLdg', @"loading" },
	{ 'DTcs', @"numberOfColumns" },
	{ 'DTrw', @"numberOfRows" },
	{ 'pgPD', @"paginatedPDF" },
	{ 'rURL', @"referenceURL" },
	{ 'DTsn', @"selectedColumn" },
	{ 'DTsc', @"selectedColumns" },
	{ 'DTsr', @"selectedRow" },
	{ 'DTsw', @"selectedRows" },
	{ 'conT', @"source" },
	{ 'thwi', @"thinkWindow" },
	{ 'pURL', @"URL" },
	{ 'subs', @"selectedText" },
	{ 'DTpl', @"plainText" },
	{ 'ctxt', @"richText" },
	{ 'pPDF', @"PDF" },
	{ 'DNav', @"webArchive" },
	{ 'DTli', @"currentLine" },
	{ 'DTmf', @"currentMovieFrame" },
	{ 'DTti', @"currentTime" },
	{ 'DTpe', @"currentPage" },
	{ 'cutb', @"currentTab" },
	{ 'DTkb', @"database" },
	{ 'DTdr', @"contentRecord" },
	{ 'iLdg', @"loading" },
	{ 'DTcs', @"numberOfColumns" },
	{ 'DTrw', @"numberOfRows" },
	{ 'pgPD', @"paginatedPDF" },
	{ 'rURL', @"referenceURL" },
	{ 'DTsn', @"selectedColumn" },
	{ 'DTsc', @"selectedColumns" },
	{ 'DTsr', @"selectedRow" },
	{ 'DTsw', @"selectedRows" },
	{ 'conT', @"source" },
	{ 'pURL', @"URL" },
	{ 'subs', @"selectedText" },
	{ 'DTpl', @"plainText" },
	{ 'ctxt', @"richText" },
	{ 'DTus', @"user" },
	{ 'DTpw', @"password" },
	{ 'CHcw', @"contextWindow" },
	{ 'CHds', @"deepSearch" },
	{ 'DTtn', @"thinking" },
	{ 'DTtl', @"toolCalls" },
	{ 'CHvi', @"vision" },
	{ 'DNti', @"title" },
	{ 'DNtc', @"textContent" },
	{ 'CHas', @"abstract" },
	{ 'CHat', @"authors" },
	{ 'pURL', @"URL" },
	{ 'DNti', @"title" },
	{ 'DNdc', @"objectDescription" },
	{ 'DNau', @"author" },
	{ 'pURL', @"URL" },
	{ 'DNtc', @"textContent" },
	{ 'conT', @"source" },
	{ 'guid', @"guid" },
	{ 'DNlm', @"lastModified" },
	{ 'tags', @"tags" },
	{ 'DNec', @"enclosures" },
	{ 'pnam', @"name" },
	{ 'DTdg', @"selectedGroup" },
	{ 'tags', @"tags" },
	{ 'HTst', @"HTTPStatus" },
	{ 'DNlm', @"lastModified" },
	{ 'HTct', @"contentType" },
	{ 'HTcl', @"contentLength" },
	{ 'HTcs', @"charset" },
	{ 'HTec', @"errorCode" },
	{ 'HTed', @"errorDomain" },
	{ 'pURL', @"URL" },
	{ 'DNti', @"title" },
	{ 'DTur', @"unread" },
	{ 'ldt ', @"date" },
	{ 'DNau', @"author" },
	{ 'DNti', @"title" },
	{ 'DNsj', @"subject" },
	{ 'DNky', @"keywords" },
	{ 0, nil } 
};

- (NSDictionary *) codesForPropertyNames
{
	static NSMutableDictionary *dict__;

	if (!dict__) @synchronized([self class]) {
	if (!dict__) {
		dict__ = [[NSMutableDictionary alloc] init];
		const codeForPropertyName_t *p;
		for (p = codeForPropertyNameData__; p->name != nil; ++p)
			[dict__ setObject:[NSNumber numberWithUnsignedInt:p->code] forKey:p->name];
	} }
	return dict__;
}


- (SBElementArray *) windows
{
	return [self elementArrayWithCode:'cwin'];
}


- (NSString *) name
{
	return [[self propertyWithCode:'pnam'] get];
}

- (BOOL) frontmost
{
	id v = [[self propertyWithCode:'pisf'] get];
	return [v boolValue];
}

- (NSString *) version
{
	return [[self propertyWithCode:'vers'] get];
}


- (void) quitSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'aevt' id:'quit' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (BOOL) exists:(id)x
{
	id result__ = [self sendEvent:'core' id:'doex' parameters:'----', x, 0];
	return [result__ boolValue];
}

- (BOOL) addCustomMetaData:(id)x for:(NSString *)for_ to:(DEVONthinkRecord *)to as:(id)as
{
	id result__ = [self sendEvent:'DTpa' id:'cd9a' parameters:'----', x, 'DTfo', for_, 'DTto', to, 'fltp', as, 0];
	return [result__ boolValue];
}

- (BOOL) addDownload:(NSString *)x automatic:(BOOL)automatic password:(id)password referrer:(id)referrer user:(id)user
{
	id result__ = [self sendEvent:'DTpa' id:'cd28' parameters:'----', x, 'DTat', [NSNumber numberWithBool:automatic], 'DTpw', password, 'DTrf', referrer, 'DTus', user, 0];
	return [result__ boolValue];
}

- (BOOL) addReadingListRecord:(id)record URL:(id)URL title:(id)title
{
	id result__ = [self sendEvent:'DTpa' id:'cd46' parameters:'DTrc', record, 'pURL', URL, 'DNti', title, 0];
	return [result__ boolValue];
}

- (id) addReminder:(NSDictionary *)x to:(DEVONthinkRecord *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cdA3' parameters:'----', x, 'DTto', to, 0];
	return result__;
}

- (NSInteger) checkFileIntegrityOfDatabase:(DEVONthinkDatabase *)database
{
	id result__ = [self sendEvent:'DTpa' id:'cdA1' parameters:'DTkb', database, 0];
	return [result__ integerValue];
}

- (id) classifyRecord:(DEVONthinkRecord *)record in:(id)in_ comparison:(DEVONthinkComparisonType)comparison tags:(BOOL)tags
{
	id result__ = [self sendEvent:'DTpa' id:'cd13' parameters:'DTrc', record, 'DTin', in_, 'DTcp', [NSAppleEventDescriptor descriptorWithEnumCode:comparison], 'tags', [NSNumber numberWithBool:tags], 0];
	return result__;
}

- (id) compareRecord:(id)record content:(id)content to:(id)to comparison:(DEVONthinkComparisonType)comparison
{
	id result__ = [self sendEvent:'DTpa' id:'cd14' parameters:'DTrc', record, 'DTcn', content, 'DTto', to, 'DTcp', [NSAppleEventDescriptor descriptorWithEnumCode:comparison], 0];
	return result__;
}

- (BOOL) compressDatabase:(DEVONthinkDatabase *)database password:(id)password to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd88' parameters:'DTkb', database, 'DTpw', password, 'DTto', to, 0];
	return [result__ boolValue];
}

- (id) convertRecord:(id)record to:(DEVONthinkConvertType)to in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd16' parameters:'DTrc', record, 'DTto', [NSAppleEventDescriptor descriptorWithEnumCode:to], 'DTin', in_, 0];
	return result__;
}

- (id) convertFeedToHTML:(NSString *)x baseURL:(id)baseURL
{
	id result__ = [self sendEvent:'DTpa' id:'cd37' parameters:'----', x, 'DTbU', baseURL, 0];
	return result__;
}

- (id) createDatabase:(NSString *)x encryptionKey:(id)encryptionKey size:(NSInteger)size
{
	id result__ = [self sendEvent:'DTpa' id:'cd20' parameters:'----', x, 'DTek', encryptionKey, 'ptsz', [NSNumber numberWithInteger:size], 0];
	return result__;
}

- (id) createFormattedNoteFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name readability:(BOOL)readability referrer:(id)referrer source:(id)source
{
	id result__ = [self sendEvent:'DTpa' id:'cd74' parameters:'----', x, 'DTag', agent, 'DTin', in_, 'pnam', name, 'DTis', [NSNumber numberWithBool:readability], 'DTrf', referrer, 'conT', source, 0];
	return result__;
}

- (id) createLocation:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd52' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) createMarkdownFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name readability:(BOOL)readability referrer:(id)referrer
{
	id result__ = [self sendEvent:'DTpa' id:'cd7a' parameters:'----', x, 'DTag', agent, 'DTin', in_, 'pnam', name, 'DTrd', [NSNumber numberWithBool:readability], 'DTrf', referrer, 0];
	return result__;
}

- (id) createPDFDocumentFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name pagination:(BOOL)pagination readability:(BOOL)readability referrer:(id)referrer width:(NSNumber *)width
{
	id result__ = [self sendEvent:'DTpa' id:'cd78' parameters:'----', x, 'DTag', agent, 'DTin', in_, 'pnam', name, 'DTpg', [NSNumber numberWithBool:pagination], 'DTis', [NSNumber numberWithBool:readability], 'DTrf', referrer, 'pwid', width, 0];
	return result__;
}

- (id) createRecordWith:(NSDictionary *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd08' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (BOOL) createThumbnailFor:(DEVONthinkRecord *)for_
{
	id result__ = [self sendEvent:'DTpa' id:'cd17' parameters:'DTfo', for_, 0];
	return [result__ boolValue];
}

- (id) createWebDocumentFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name readability:(BOOL)readability referrer:(id)referrer
{
	id result__ = [self sendEvent:'DTpa' id:'cd77' parameters:'----', x, 'DTag', agent, 'DTin', in_, 'pnam', name, 'DTis', [NSNumber numberWithBool:readability], 'DTrf', referrer, 0];
	return result__;
}

- (BOOL) deleteRecord:(id)record in:(id)in_
{
	id result__ = [self sendEvent:'core' id:'delo' parameters:'DTrc', record, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (BOOL) deleteThumbnailOf:(DEVONthinkRecord *)of
{
	id result__ = [self sendEvent:'DTpa' id:'cd19' parameters:'DTof', of, 0];
	return [result__ boolValue];
}

- (BOOL) deleteWorkspace:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd85' parameters:'----', x, 0];
	return [result__ boolValue];
}

- (id) doJavaScript:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'dojs' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) downloadImageForPrompt:(NSString *)x promptStrength:(double)promptStrength image:(id)image engine:(DEVONthinkImageEngine)engine quality:(NSString *)quality aspectRatio:(NSString *)aspectRatio style:(NSString *)style seed:(NSInteger)seed
{
	id result__ = [self sendEvent:'DTpa' id:'cda3' parameters:'----', x, 'DTot', [NSNumber numberWithDouble:promptStrength], 'imaA', image, 'DTeg', [NSAppleEventDescriptor descriptorWithEnumCode:engine], 'DTqa', quality, 'ptar', aspectRatio, 'DTsy', style, 'DTse', [NSNumber numberWithInteger:seed], 0];
	return result__;
}

- (id) downloadJSONFrom:(NSString *)x agent:(id)agent method:(id)method password:(id)password post:(id)post referrer:(id)referrer user:(id)user
{
	id result__ = [self sendEvent:'DTpa' id:'cd9b' parameters:'----', x, 'DTag', agent, 'DTme', method, 'DTpw', password, 'DTps', post, 'DTrf', referrer, 'DTus', user, 0];
	return result__;
}

- (id) downloadMarkupFrom:(NSString *)x agent:(id)agent encoding:(id)encoding method:(id)method password:(id)password post:(id)post referrer:(id)referrer user:(id)user
{
	id result__ = [self sendEvent:'DTpa' id:'cd36' parameters:'----', x, 'DTag', agent, 'DTec', encoding, 'DTme', method, 'DTpw', password, 'DTps', post, 'DTrf', referrer, 'DTus', user, 0];
	return result__;
}

- (id) downloadURL:(NSString *)x agent:(id)agent method:(id)method password:(id)password post:(id)post referrer:(id)referrer user:(id)user
{
	id result__ = [self sendEvent:'DTpa' id:'cd26' parameters:'----', x, 'DTag', agent, 'DTme', method, 'DTpw', password, 'DTps', post, 'DTrf', referrer, 'DTus', user, 0];
	return result__;
}

- (id) displayAuthenticationDialog
{
	id result__ = [self sendEvent:'DTpa' id:'cd84' parameters:0];
	return result__;
}

- (id) displayDateEditorDefaultDate:(id)defaultDate info:(id)info
{
	id result__ = [self sendEvent:'DTpa' id:'cd9f' parameters:'dfdt', defaultDate, 'info', info, 0];
	return result__;
}

- (id) displayGroupSelectorButtons:(id)buttons for:(id)for_ name:(BOOL)name tags:(BOOL)tags
{
	id result__ = [self sendEvent:'DTpa' id:'cd39' parameters:'DTbt', buttons, 'DTfo', for_, 'pnam', [NSNumber numberWithBool:name], 'tags', [NSNumber numberWithBool:tags], 0];
	return result__;
}

- (id) displayNameEditorDefaultAnswer:(id)defaultAnswer info:(id)info
{
	id result__ = [self sendEvent:'DTpa' id:'cd89' parameters:'dtxt', defaultAnswer, 'info', info, 0];
	return result__;
}

- (id) duplicateRecord:(id)record to:(DEVONthinkParent *)to
{
	id result__ = [self sendEvent:'core' id:'clon' parameters:'DTrc', record, 'DTto', to, 0];
	return result__;
}

- (BOOL) existsRecordAt:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd53' parameters:'----', x, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (BOOL) existsRecordWithComment:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd59' parameters:'----', x, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (BOOL) existsRecordWithContentHash:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd9d' parameters:'----', x, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (BOOL) existsRecordWithFile:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd91' parameters:'----', x, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (BOOL) existsRecordWithPath:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd66' parameters:'----', x, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (BOOL) existsRecordWithURL:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd65' parameters:'----', x, 'DTin', in_, 0];
	return [result__ boolValue];
}

- (id) exportRecord:(DEVONthinkRecord *)record to:(NSString *)to DEVONtech_Storage:(BOOL)DEVONtech_Storage
{
	id result__ = [self sendEvent:'DTpa' id:'cd04' parameters:'DTrc', record, 'DTto', to, 'DNTs', [NSNumber numberWithBool:DEVONtech_Storage], 0];
	return result__;
}

- (BOOL) exportTagsOfRecord:(DEVONthinkRecord *)record
{
	id result__ = [self sendEvent:'DTpa' id:'cd76' parameters:'DTrc', record, 0];
	return [result__ boolValue];
}

- (id) exportWebsiteRecord:(DEVONthinkRecord *)record to:(NSString *)to template:(id)template_ indexPages:(BOOL)indexPages encoding:(id)encoding entities:(BOOL)entities
{
	id result__ = [self sendEvent:'DTpa' id:'cd54' parameters:'DTrc', record, 'DTto', to, 'DTtp', template_, 'DTip', [NSNumber numberWithBool:indexPages], 'DTec', encoding, 'DTen', [NSNumber numberWithBool:entities], 0];
	return result__;
}

- (id) extractKeywordsFromRecord:(DEVONthinkRecord *)record barcodes:(BOOL)barcodes existingTags:(BOOL)existingTags hashTags:(BOOL)hashTags imageTags:(BOOL)imageTags
{
	id result__ = [self sendEvent:'DTpa' id:'cd81' parameters:'DTrc', record, 'DTbc', [NSNumber numberWithBool:barcodes], 'DTet', [NSNumber numberWithBool:existingTags], 'DTht', [NSNumber numberWithBool:hashTags], 'DTit', [NSNumber numberWithBool:imageTags], 0];
	return result__;
}

- (id) getCachedDataForURL:(NSString *)x from:(id)from
{
	id result__ = [self sendEvent:'DTpa' id:'cd83' parameters:'----', x, 'DTfr', from, 0];
	return result__;
}

- (id) getChatCapabilitiesForEngine:(DEVONthinkChatEngine)x model:(NSString *)model
{
	id result__ = [self sendEvent:'DTpa' id:'cdb1' parameters:'----', [NSAppleEventDescriptor descriptorWithEnumCode:x], 'DTmd', model, 0];
	return result__;
}

- (NSArray<NSString *> *) getChatModelsForEngine:(DEVONthinkChatEngine)x
{
	id result__ = [self sendEvent:'DTpa' id:'cdb0' parameters:'----', [NSAppleEventDescriptor descriptorWithEnumCode:x], 0];
	return result__;
}

- (id) getChatResponseForMessage:(id)x record:(id)record mode:(id)mode image:(id)image URL:(id)URL model:(id)model role:(id)role engine:(DEVONthinkChatEngine)engine temperature:(double)temperature thinking:(BOOL)thinking toolCalls:(BOOL)toolCalls usage:(DEVONthinkChatUsage)usage as:(id)as
{
	id result__ = [self sendEvent:'DTpa' id:'cda2' parameters:'----', x, 'DTrc', record, 'DTmu', mode, 'imaA', image, 'pURL', URL, 'DTmd', model, 'Drol', role, 'DTeg', [NSAppleEventDescriptor descriptorWithEnumCode:engine], 'DTtm', [NSNumber numberWithDouble:temperature], 'DTtn', [NSNumber numberWithBool:thinking], 'DTtl', [NSNumber numberWithBool:toolCalls], 'DTug', [NSAppleEventDescriptor descriptorWithEnumCode:usage], 'fltp', as, 0];
	return result__;
}

- (id) getConcordanceOfRecord:(DEVONthinkContent *)record sortedBy:(DEVONthinkConcordanceSorting)sortedBy
{
	id result__ = [self sendEvent:'DTpa' id:'cd87' parameters:'DTrc', record, 'DTor', [NSAppleEventDescriptor descriptorWithEnumCode:sortedBy], 0];
	return result__;
}

- (id) getCustomMetaDataDefaultValue:(id)defaultValue for:(NSString *)for_ from:(DEVONthinkRecord *)from
{
	id result__ = [self sendEvent:'DTpa' id:'cd9c' parameters:'DTdv', defaultValue, 'DTfo', for_, 'DTfr', from, 0];
	return result__;
}

- (id) getDatabaseWithId:(NSInteger)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd42' parameters:'----', [NSNumber numberWithInteger:x], 0];
	return result__;
}

- (id) getDatabaseWithUuid:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd44' parameters:'----', x, 0];
	return result__;
}

- (id) getEmbeddedImagesOf:(NSString *)x baseURL:(id)baseURL fileType:(id)fileType
{
	id result__ = [self sendEvent:'DTpa' id:'cd31' parameters:'----', x, 'DTbU', baseURL, 'FIty', fileType, 0];
	return result__;
}

- (id) getEmbeddedObjectsOf:(NSString *)x baseURL:(id)baseURL fileType:(id)fileType
{
	id result__ = [self sendEvent:'DTpa' id:'cd32' parameters:'----', x, 'DTbU', baseURL, 'FIty', fileType, 0];
	return result__;
}

- (id) getEmbeddedSheetsAndScriptsOf:(NSString *)x baseURL:(id)baseURL fileType:(id)fileType
{
	id result__ = [self sendEvent:'DTpa' id:'cd51' parameters:'----', x, 'DTbU', baseURL, 'FIty', fileType, 0];
	return result__;
}

- (id) getFaviconOf:(NSString *)x baseURL:(id)baseURL
{
	id result__ = [self sendEvent:'DTpa' id:'cda1' parameters:'----', x, 'DTbU', baseURL, 0];
	return result__;
}

- (id) getFeedItemsOf:(NSString *)x baseURL:(id)baseURL
{
	id result__ = [self sendEvent:'DTpa' id:'cdA5' parameters:'----', x, 'DTbU', baseURL, 0];
	return result__;
}

- (id) getFramesOf:(NSString *)x baseURL:(id)baseURL
{
	id result__ = [self sendEvent:'DTpa' id:'cd33' parameters:'----', x, 'DTbU', baseURL, 0];
	return result__;
}

- (id) getItemsOfFeed:(NSString *)x baseURL:(id)baseURL
{
	id result__ = [self sendEvent:'DTpa' id:'cd71' parameters:'----', x, 'DTbU', baseURL, 0];
	return result__;
}

- (id) getLinksOf:(NSString *)x baseURL:(id)baseURL containing:(id)containing fileType:(id)fileType
{
	id result__ = [self sendEvent:'DTpa' id:'cd30' parameters:'----', x, 'DTbU', baseURL, 'DTct', containing, 'FIty', fileType, 0];
	return result__;
}

- (id) getMetadataOf:(NSString *)x baseURL:(id)baseURL markdown:(id)markdown
{
	id result__ = [self sendEvent:'DTpa' id:'cda4' parameters:'----', x, 'DTbU', baseURL, 'mkdn', markdown, 0];
	return result__;
}

- (id) getRecordAt:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd23' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) getRecordWithId:(NSInteger)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd35' parameters:'----', [NSNumber numberWithInteger:x], 'DTin', in_, 0];
	return result__;
}

- (id) getRecordWithUuid:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd86' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) getRichTextOf:(NSString *)x baseURL:(id)baseURL
{
	id result__ = [self sendEvent:'DTpa' id:'cd69' parameters:'----', x, 'DTbU', baseURL, 0];
	return result__;
}

- (id) getTextOf:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd68' parameters:'----', x, 0];
	return result__;
}

- (id) getTitleOf:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd38' parameters:'----', x, 0];
	return result__;
}

- (id) getVersionsOfRecord:(DEVONthinkRecord *)record
{
	id result__ = [self sendEvent:'DTpa' id:'cda7' parameters:'DTrc', record, 0];
	return result__;
}

- (BOOL) hideProgressIndicator
{
	id result__ = [self sendEvent:'DTpa' id:'cd43' parameters:0];
	return [result__ boolValue];
}

- (id) importAttachmentsOfRecord:(DEVONthinkRecord *)record to:(id)to
{
	id result__ = [self sendEvent:'DTpa' id:'cdA6' parameters:'DTrc', record, 'DTto', to, 0];
	return result__;
}

- (id) importPath:(NSString *)x from:(id)from name:(id)name placeholders:(id)placeholders to:(id)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd01' parameters:'----', x, 'DTfr', from, 'pnam', name, 'DTph', placeholders, 'DTto', to, 0];
	return result__;
}

- (id) importTemplate:(NSString *)x to:(id)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd67' parameters:'----', x, 'DTto', to, 0];
	return result__;
}

- (id) indexPath:(NSString *)x to:(id)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd45' parameters:'----', x, 'DTto', to, 0];
	return result__;
}

- (BOOL) loadWorkspace:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd99' parameters:'----', x, 0];
	return [result__ boolValue];
}

- (BOOL) logMessageRecord:(id)record info:(id)info
{
	id result__ = [self sendEvent:'DTpa' id:'cd80' parameters:'DTrc', record, 'info', info, 0];
	return [result__ boolValue];
}

- (id) lookupRecordsWithComment:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd58' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) lookupRecordsWithContentHash:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd9e' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) lookupRecordsWithFile:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd90' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) lookupRecordsWithPath:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd50' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) lookupRecordsWithTags:(NSArray<NSString *> *)x any:(BOOL)any in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd92' parameters:'----', x, 'any ', [NSNumber numberWithBool:any], 'DTin', in_, 0];
	return result__;
}

- (id) lookupRecordsWithURL:(NSString *)x in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd49' parameters:'----', x, 'DTin', in_, 0];
	return result__;
}

- (id) mergeIn:(id)in_ records:(NSArray<DEVONthinkRecord *> *)records
{
	id result__ = [self sendEvent:'DTpa' id:'cd94' parameters:'DTin', in_, 'DTrs', records, 0];
	return result__;
}

- (id) moveRecord:(id)record from:(id)from to:(DEVONthinkParent *)to
{
	id result__ = [self sendEvent:'core' id:'move' parameters:'DTrc', record, 'DTfr', from, 'DTto', to, 0];
	return result__;
}

- (BOOL) moveIntoDatabaseRecord:(DEVONthinkRecord *)record
{
	id result__ = [self sendEvent:'DTpa' id:'cd97' parameters:'DTrc', record, 0];
	return [result__ boolValue];
}

- (BOOL) moveToExternalFolderRecord:(DEVONthinkRecord *)record to:(id)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd98' parameters:'DTrc', record, 'DTto', to, 0];
	return [result__ boolValue];
}

- (id) openDatabase:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd21' parameters:'----', x, 0];
	return result__;
}

- (id) openTabForRecord:(id)record URL:(id)URL referrer:(id)referrer in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd82' parameters:'DTrc', record, 'pURL', URL, 'DTrf', referrer, 'DTin', in_, 0];
	return result__;
}

- (id) openWindowForRecord:(DEVONthinkRecord *)record enforcement:(BOOL)enforcement
{
	id result__ = [self sendEvent:'DTpa' id:'cd75' parameters:'DTrc', record, 'DTef', [NSNumber numberWithBool:enforcement], 0];
	return result__;
}

- (BOOL) optimizeDatabase:(DEVONthinkDatabase *)database
{
	id result__ = [self sendEvent:'DTpa' id:'cd24' parameters:'DTkb', database, 0];
	return [result__ boolValue];
}

- (id) pasteClipboardTo:(id)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd73' parameters:'DTto', to, 0];
	return result__;
}

- (BOOL) performBatchConfiguration:(NSString *)x record:(id)record
{
	id result__ = [self sendEvent:'DTpa' id:'cdb2' parameters:'----', x, 'DTrc', record, 0];
	return [result__ boolValue];
}

- (id) performChatResearch:(NSString *)x sources:(NSArray<NSString *> *)sources maximumResults:(NSInteger)maximumResults
{
	id result__ = [self sendEvent:'DTpa' id:'cdaf' parameters:'----', x, 'DTrs', sources, 'DTmr', [NSNumber numberWithInteger:maximumResults], 0];
	return result__;
}

- (BOOL) performSmartRuleName:(id)name record:(id)record trigger:(DEVONthinkRuleEvent)trigger
{
	id result__ = [self sendEvent:'DTpa' id:'cda0' parameters:'pnam', name, 'DTrc', record, 'DTtr', [NSAppleEventDescriptor descriptorWithEnumCode:trigger], 0];
	return [result__ boolValue];
}

- (BOOL) refreshRecord:(DEVONthinkRecord *)record
{
	id result__ = [self sendEvent:'DTpa' id:'cd47' parameters:'DTrc', record, 0];
	return [result__ boolValue];
}

- (id) replicateRecord:(id)record to:(DEVONthinkParent *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd06' parameters:'DTrc', record, 'DTto', to, 0];
	return result__;
}

- (BOOL) restoreRecordWithVersion:(DEVONthinkRecord *)version
{
	id result__ = [self sendEvent:'DTpa' id:'cda8' parameters:'vers', version, 0];
	return [result__ boolValue];
}

- (id) saveVersionOfRecord:(DEVONthinkRecord *)record
{
	id result__ = [self sendEvent:'DTpa' id:'cda6' parameters:'DTrc', record, 0];
	return result__;
}

- (BOOL) saveWorkspace:(NSString *)x
{
	id result__ = [self sendEvent:'DTpa' id:'cd93' parameters:'----', x, 0];
	return [result__ boolValue];
}

- (id) search:(NSString *)x comparison:(DEVONthinkSearchComparison)comparison excludeSubgroups:(BOOL)excludeSubgroups in:(id)in_
{
	id result__ = [self sendEvent:'DTpa' id:'cd15' parameters:'----', x, 'DTcp', [NSAppleEventDescriptor descriptorWithEnumCode:comparison], 'DTqx', [NSNumber numberWithBool:excludeSubgroups], 'DTin', in_, 0];
	return result__;
}

- (BOOL) showProgressIndicator:(NSString *)x cancelButton:(BOOL)cancelButton steps:(NSNumber *)steps
{
	id result__ = [self sendEvent:'DTpa' id:'cd40' parameters:'----', x, 'DTcb', [NSNumber numberWithBool:cancelButton], 'DTsp', steps, 0];
	return [result__ boolValue];
}

- (BOOL) showSearch
{
	id result__ = [self sendEvent:'DTpa' id:'cdaa' parameters:0];
	return [result__ boolValue];
}

- (BOOL) startDownloads
{
	id result__ = [self sendEvent:'DTpa' id:'cd95' parameters:0];
	return [result__ boolValue];
}

- (BOOL) stepProgressIndicator
{
	id result__ = [self sendEvent:'DTpa' id:'cd41' parameters:0];
	return [result__ boolValue];
}

- (BOOL) stopDownloads
{
	id result__ = [self sendEvent:'DTpa' id:'cd96' parameters:0];
	return [result__ boolValue];
}

- (id) summarizeAnnotationsOfIn:(id)in_ records:(NSArray<DEVONthinkContent *> *)records to:(DEVONthinkSummaryType)to
{
	id result__ = [self sendEvent:'DTpa' id:'cdA0' parameters:'DTin', in_, 'DTrs', records, 'DTto', [NSAppleEventDescriptor descriptorWithEnumCode:to], 0];
	return result__;
}

- (id) summarizeContentsOfIn:(id)in_ records:(NSArray<DEVONthinkContent *> *)records to:(DEVONthinkSummaryType)to as:(DEVONthinkSummaryStyle)as
{
	id result__ = [self sendEvent:'DTpa' id:'cdA4' parameters:'DTin', in_, 'DTrs', records, 'DTto', [NSAppleEventDescriptor descriptorWithEnumCode:to], 'fltp', [NSAppleEventDescriptor descriptorWithEnumCode:as], 0];
	return result__;
}

- (id) summarizeMentionsOfIn:(id)in_ records:(NSArray<DEVONthinkContent *> *)records to:(DEVONthinkSummaryType)to
{
	id result__ = [self sendEvent:'DTpa' id:'cdA2' parameters:'DTin', in_, 'DTrs', records, 'DTto', [NSAppleEventDescriptor descriptorWithEnumCode:to], 0];
	return result__;
}

- (id) summarizeText:(NSString *)x as:(DEVONthinkSummaryStyle)as
{
	id result__ = [self sendEvent:'DTpa' id:'cdB0' parameters:'----', x, 'fltp', [NSAppleEventDescriptor descriptorWithEnumCode:as], 0];
	return result__;
}

- (BOOL) synchronizeRecord:(id)record database:(id)database
{
	id result__ = [self sendEvent:'DTpa' id:'cd48' parameters:'DTrc', record, 'DTkb', database, 0];
	return [result__ boolValue];
}

- (id) transcribeRecord:(DEVONthinkContent *)record language:(NSString *)language timestamps:(BOOL)timestamps
{
	id result__ = [self sendEvent:'DTpa' id:'cda5' parameters:'DTrc', record, 'lang', language, 'tist', [NSNumber numberWithBool:timestamps], 0];
	return result__;
}

- (BOOL) updateRecord:(DEVONthinkRecord *)record withText:(id)withText mode:(DEVONthinkUpdateMode)mode URL:(id)URL
{
	id result__ = [self sendEvent:'DTpa' id:'cda9' parameters:'DTrc', record, 'DTwt', withText, 'DTmu', [NSAppleEventDescriptor descriptorWithEnumCode:mode], 'pURL', URL, 0];
	return [result__ boolValue];
}

- (BOOL) updateThumbnailOf:(DEVONthinkRecord *)of
{
	id result__ = [self sendEvent:'DTpa' id:'cd18' parameters:'DTof', of, 0];
	return [result__ boolValue];
}

- (NSInteger) verifyDatabase:(DEVONthinkDatabase *)database
{
	id result__ = [self sendEvent:'DTpa' id:'cd29' parameters:'DTkb', database, 0];
	return [result__ integerValue];
}

- (id) convertImageRecord:(DEVONthinkContent *)record to:(id)to fileType:(DEVONthinkOCRConvertType)fileType waitingForReply:(BOOL)waitingForReply
{
	id result__ = [self sendEvent:'DTor' id:'OCR0' parameters:'DTrc', record, 'DTto', to, 'FIty', [NSAppleEventDescriptor descriptorWithEnumCode:fileType], 'OCRc', [NSNumber numberWithBool:waitingForReply], 0];
	return result__;
}

- (id) ocrFile:(NSString *)file attributes:(id)attributes to:(id)to fileType:(DEVONthinkOCRConvertType)fileType waitingForReply:(BOOL)waitingForReply
{
	id result__ = [self sendEvent:'DTor' id:'OCR1' parameters:'furl', file, 'OCRa', attributes, 'DTto', to, 'FIty', [NSAppleEventDescriptor descriptorWithEnumCode:fileType], 'OCRc', [NSNumber numberWithBool:waitingForReply], 0];
	return result__;
}

- (id) imprinterConfigurationNames
{
	id result__ = [self sendEvent:'DTim' id:'ICN1' parameters:0];
	return result__;
}

- (BOOL) imprintConfiguration:(NSString *)x to:(DEVONthinkContent *)to waitingForReply:(BOOL)waitingForReply
{
	id result__ = [self sendEvent:'DTim' id:'IMP0' parameters:'----', x, 'IMrc', to, 'OCRc', [NSNumber numberWithBool:waitingForReply], 0];
	return [result__ boolValue];
}

- (BOOL) imprintRecord:(DEVONthinkContent *)record backgroundColor:(id)backgroundColor borderColor:(id)borderColor borderStyle:(DEVONthinkBorderStyleType)borderStyle borderWidth:(NSInteger)borderWidth font:(NSString *)font foregroundColor:(id)foregroundColor occurence:(DEVONthinkOccurrenceType)occurence outlined:(BOOL)outlined position:(DEVONthinkImprintPosition)position rotation:(NSInteger)rotation size:(NSInteger)size strikeThrough:(BOOL)strikeThrough text:(NSString *)text underlined:(BOOL)underlined xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset waitingForReply:(BOOL)waitingForReply
{
	id result__ = [self sendEvent:'DTim' id:'IMW1' parameters:'DTrc', record, 'IMBK', backgroundColor, 'IMBC', borderColor, 'IF08', [NSAppleEventDescriptor descriptorWithEnumCode:borderStyle], 'IF09', [NSNumber numberWithInteger:borderWidth], 'font', font, 'IMFC', foregroundColor, 'IF13', [NSAppleEventDescriptor descriptorWithEnumCode:occurence], 'IF07', [NSNumber numberWithBool:outlined], 'kpos', [NSAppleEventDescriptor descriptorWithEnumCode:position], 'IF10', [NSNumber numberWithInteger:rotation], 'ptsz', [NSNumber numberWithInteger:size], 'IF06', [NSNumber numberWithBool:strikeThrough], 'IF01', text, 'DAun', [NSNumber numberWithBool:underlined], 'IF11', [NSNumber numberWithInteger:xOffset], 'IF12', [NSNumber numberWithInteger:yOffset], 'OCRc', [NSNumber numberWithBool:waitingForReply], 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkWindow

- (NSString *) name
{
	return [[self propertyWithCode:'pnam'] get];
}

- (NSInteger) id
{
	id v = [[self propertyWithCode:'ID  '] get];
	return [v integerValue];
}

- (NSInteger) index
{
	id v = [[self propertyWithCode:'pidx'] get];
	return [v integerValue];
}

- (void) setIndex: (NSInteger) index
{
	id v = [NSNumber numberWithInteger:index];
	[[self propertyWithCode:'pidx'] setTo:v];
}

- (NSRect) bounds
{
	id v = [[self propertyWithCode:'pbnd'] get];
	return [v rectValue];
}

- (void) setBounds: (NSRect) bounds
{
	id v = [NSValue valueWithRect:bounds];
	[[self propertyWithCode:'pbnd'] setTo:v];
}

- (BOOL) closeable
{
	id v = [[self propertyWithCode:'hclb'] get];
	return [v boolValue];
}

- (BOOL) miniaturizable
{
	id v = [[self propertyWithCode:'ismn'] get];
	return [v boolValue];
}

- (BOOL) miniaturized
{
	id v = [[self propertyWithCode:'pmnd'] get];
	return [v boolValue];
}

- (void) setMiniaturized: (BOOL) miniaturized
{
	id v = [NSNumber numberWithBool:miniaturized];
	[[self propertyWithCode:'pmnd'] setTo:v];
}

- (BOOL) resizable
{
	id v = [[self propertyWithCode:'prsz'] get];
	return [v boolValue];
}

- (BOOL) visible
{
	id v = [[self propertyWithCode:'pvis'] get];
	return [v boolValue];
}

- (void) setVisible: (BOOL) visible
{
	id v = [NSNumber numberWithBool:visible];
	[[self propertyWithCode:'pvis'] setTo:v];
}

- (BOOL) zoomable
{
	id v = [[self propertyWithCode:'iszm'] get];
	return [v boolValue];
}

- (BOOL) zoomed
{
	id v = [[self propertyWithCode:'pzum'] get];
	return [v boolValue];
}

- (void) setZoomed: (BOOL) zoomed
{
	id v = [NSNumber numberWithBool:zoomed];
	[[self propertyWithCode:'pzum'] setTo:v];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end




/*
 * Text Suite
 */

@implementation DEVONthinkRichText

- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}


- (BOOL) addCustomMetaDataFor:(NSString *)for_ to:(DEVONthinkRecord *)to as:(id)as
{
	id result__ = [self sendEvent:'DTpa' id:'cd9a' parameters:'DTfo', for_, 'DTto', to, 'fltp', as, 0];
	return [result__ boolValue];
}


- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkAttachment

- (id) fileName
{
	return (id) [self propertyWithCode:'atfn'];
}

- (void) setFileName: (id) fileName
{
	[[self propertyWithCode:'atfn'] setTo:fileName];
}


@end


@implementation DEVONthinkAttributeRun

- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkCharacter

- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkParagraph

- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkWord

- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end




/*
 * Extended Text Suite
 */

@implementation DEVONthinkAttachment(ExtendedTextSuite)


- (id) fileName
{
	return (id) [self propertyWithCode:'atfn'];
}

- (void) setFileName: (id) fileName
{
	[[self propertyWithCode:'atfn'] setTo:fileName];
}

@end


@implementation DEVONthinkRichText(ExtendedTextSuite)


- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (double) baselineOffset
{
	id v = [[self propertyWithCode:'DAbo'] get];
	return [v doubleValue];
}

- (void) setBaselineOffset: (double) baselineOffset
{
	id v = [NSNumber numberWithDouble:baselineOffset];
	[[self propertyWithCode:'DAbo'] setTo:v];
}

- (id) background
{
	return (id) [self propertyWithCode:'DAbc'];
}

- (void) setBackground: (id) background
{
	[[self propertyWithCode:'DAbc'] setTo:background];
}

- (double) firstLineHeadIndent
{
	id v = [[self propertyWithCode:'DAfl'] get];
	return [v doubleValue];
}

- (void) setFirstLineHeadIndent: (double) firstLineHeadIndent
{
	id v = [NSNumber numberWithDouble:firstLineHeadIndent];
	[[self propertyWithCode:'DAfl'] setTo:v];
}

- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}

- (double) headIndent
{
	id v = [[self propertyWithCode:'DAhi'] get];
	return [v doubleValue];
}

- (void) setHeadIndent: (double) headIndent
{
	id v = [NSNumber numberWithDouble:headIndent];
	[[self propertyWithCode:'DAhi'] setTo:v];
}

- (BOOL) underlined
{
	id v = [[self propertyWithCode:'DAun'] get];
	return [v boolValue];
}

- (void) setUnderlined: (BOOL) underlined
{
	id v = [NSNumber numberWithBool:underlined];
	[[self propertyWithCode:'DAun'] setTo:v];
}

- (double) lineSpacing
{
	id v = [[self propertyWithCode:'DAls'] get];
	return [v doubleValue];
}

- (void) setLineSpacing: (double) lineSpacing
{
	id v = [NSNumber numberWithDouble:lineSpacing];
	[[self propertyWithCode:'DAls'] setTo:v];
}

- (double) multipleLineHeight
{
	id v = [[self propertyWithCode:'DAlh'] get];
	return [v doubleValue];
}

- (void) setMultipleLineHeight: (double) multipleLineHeight
{
	id v = [NSNumber numberWithDouble:multipleLineHeight];
	[[self propertyWithCode:'DAlh'] setTo:v];
}

- (double) maximumLineHeight
{
	id v = [[self propertyWithCode:'DAmx'] get];
	return [v doubleValue];
}

- (void) setMaximumLineHeight: (double) maximumLineHeight
{
	id v = [NSNumber numberWithDouble:maximumLineHeight];
	[[self propertyWithCode:'DAmx'] setTo:v];
}

- (double) minimumLineHeight
{
	id v = [[self propertyWithCode:'DAmi'] get];
	return [v doubleValue];
}

- (void) setMinimumLineHeight: (double) minimumLineHeight
{
	id v = [NSNumber numberWithDouble:minimumLineHeight];
	[[self propertyWithCode:'DAmi'] setTo:v];
}

- (double) paragraphSpacing
{
	id v = [[self propertyWithCode:'DAps'] get];
	return [v doubleValue];
}

- (void) setParagraphSpacing: (double) paragraphSpacing
{
	id v = [NSNumber numberWithDouble:paragraphSpacing];
	[[self propertyWithCode:'DAps'] setTo:v];
}

- (NSInteger) superscript
{
	id v = [[self propertyWithCode:'DAss'] get];
	return [v integerValue];
}

- (void) setSuperscript: (NSInteger) superscript
{
	id v = [NSNumber numberWithInteger:superscript];
	[[self propertyWithCode:'DAss'] setTo:v];
}

- (double) tailIndent
{
	id v = [[self propertyWithCode:'DAti'] get];
	return [v doubleValue];
}

- (void) setTailIndent: (double) tailIndent
{
	id v = [NSNumber numberWithDouble:tailIndent];
	[[self propertyWithCode:'DAti'] setTo:v];
}

- (id) textContent
{
	return (id) [self propertyWithCode:'DNtc'];
}

- (void) setTextContent: (id) textContent
{
	[[self propertyWithCode:'DNtc'] setTo:textContent];
}

- (DEVONthinkTextAlignment) alignment
{
	id v = [[self propertyWithCode:'DAta'] get];
	return [v enumCodeValue];
}

- (void) setAlignment: (DEVONthinkTextAlignment) alignment
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:alignment];
	[[self propertyWithCode:'DAta'] setTo:v];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

@end


@implementation DEVONthinkAttributeRun(ExtendedTextSuite)


- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (double) baselineOffset
{
	id v = [[self propertyWithCode:'DAbo'] get];
	return [v doubleValue];
}

- (void) setBaselineOffset: (double) baselineOffset
{
	id v = [NSNumber numberWithDouble:baselineOffset];
	[[self propertyWithCode:'DAbo'] setTo:v];
}

- (id) background
{
	return (id) [self propertyWithCode:'DAbc'];
}

- (void) setBackground: (id) background
{
	[[self propertyWithCode:'DAbc'] setTo:background];
}

- (double) firstLineHeadIndent
{
	id v = [[self propertyWithCode:'DAfl'] get];
	return [v doubleValue];
}

- (void) setFirstLineHeadIndent: (double) firstLineHeadIndent
{
	id v = [NSNumber numberWithDouble:firstLineHeadIndent];
	[[self propertyWithCode:'DAfl'] setTo:v];
}

- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}

- (double) headIndent
{
	id v = [[self propertyWithCode:'DAhi'] get];
	return [v doubleValue];
}

- (void) setHeadIndent: (double) headIndent
{
	id v = [NSNumber numberWithDouble:headIndent];
	[[self propertyWithCode:'DAhi'] setTo:v];
}

- (BOOL) underlined
{
	id v = [[self propertyWithCode:'DAun'] get];
	return [v boolValue];
}

- (void) setUnderlined: (BOOL) underlined
{
	id v = [NSNumber numberWithBool:underlined];
	[[self propertyWithCode:'DAun'] setTo:v];
}

- (double) lineSpacing
{
	id v = [[self propertyWithCode:'DAls'] get];
	return [v doubleValue];
}

- (void) setLineSpacing: (double) lineSpacing
{
	id v = [NSNumber numberWithDouble:lineSpacing];
	[[self propertyWithCode:'DAls'] setTo:v];
}

- (double) multipleLineHeight
{
	id v = [[self propertyWithCode:'DAlh'] get];
	return [v doubleValue];
}

- (void) setMultipleLineHeight: (double) multipleLineHeight
{
	id v = [NSNumber numberWithDouble:multipleLineHeight];
	[[self propertyWithCode:'DAlh'] setTo:v];
}

- (double) maximumLineHeight
{
	id v = [[self propertyWithCode:'DAmx'] get];
	return [v doubleValue];
}

- (void) setMaximumLineHeight: (double) maximumLineHeight
{
	id v = [NSNumber numberWithDouble:maximumLineHeight];
	[[self propertyWithCode:'DAmx'] setTo:v];
}

- (double) minimumLineHeight
{
	id v = [[self propertyWithCode:'DAmi'] get];
	return [v doubleValue];
}

- (void) setMinimumLineHeight: (double) minimumLineHeight
{
	id v = [NSNumber numberWithDouble:minimumLineHeight];
	[[self propertyWithCode:'DAmi'] setTo:v];
}

- (double) paragraphSpacing
{
	id v = [[self propertyWithCode:'DAps'] get];
	return [v doubleValue];
}

- (void) setParagraphSpacing: (double) paragraphSpacing
{
	id v = [NSNumber numberWithDouble:paragraphSpacing];
	[[self propertyWithCode:'DAps'] setTo:v];
}

- (NSInteger) superscript
{
	id v = [[self propertyWithCode:'DAss'] get];
	return [v integerValue];
}

- (void) setSuperscript: (NSInteger) superscript
{
	id v = [NSNumber numberWithInteger:superscript];
	[[self propertyWithCode:'DAss'] setTo:v];
}

- (double) tailIndent
{
	id v = [[self propertyWithCode:'DAti'] get];
	return [v doubleValue];
}

- (void) setTailIndent: (double) tailIndent
{
	id v = [NSNumber numberWithDouble:tailIndent];
	[[self propertyWithCode:'DAti'] setTo:v];
}

- (id) textContent
{
	return (id) [self propertyWithCode:'DNtc'];
}

- (void) setTextContent: (id) textContent
{
	[[self propertyWithCode:'DNtc'] setTo:textContent];
}

- (DEVONthinkTextAlignment) alignment
{
	id v = [[self propertyWithCode:'DAta'] get];
	return [v enumCodeValue];
}

- (void) setAlignment: (DEVONthinkTextAlignment) alignment
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:alignment];
	[[self propertyWithCode:'DAta'] setTo:v];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

@end


@implementation DEVONthinkCharacter(ExtendedTextSuite)


- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (double) baselineOffset
{
	id v = [[self propertyWithCode:'DAbo'] get];
	return [v doubleValue];
}

- (void) setBaselineOffset: (double) baselineOffset
{
	id v = [NSNumber numberWithDouble:baselineOffset];
	[[self propertyWithCode:'DAbo'] setTo:v];
}

- (id) background
{
	return (id) [self propertyWithCode:'DAbc'];
}

- (void) setBackground: (id) background
{
	[[self propertyWithCode:'DAbc'] setTo:background];
}

- (double) firstLineHeadIndent
{
	id v = [[self propertyWithCode:'DAfl'] get];
	return [v doubleValue];
}

- (void) setFirstLineHeadIndent: (double) firstLineHeadIndent
{
	id v = [NSNumber numberWithDouble:firstLineHeadIndent];
	[[self propertyWithCode:'DAfl'] setTo:v];
}

- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}

- (double) headIndent
{
	id v = [[self propertyWithCode:'DAhi'] get];
	return [v doubleValue];
}

- (void) setHeadIndent: (double) headIndent
{
	id v = [NSNumber numberWithDouble:headIndent];
	[[self propertyWithCode:'DAhi'] setTo:v];
}

- (BOOL) underlined
{
	id v = [[self propertyWithCode:'DAun'] get];
	return [v boolValue];
}

- (void) setUnderlined: (BOOL) underlined
{
	id v = [NSNumber numberWithBool:underlined];
	[[self propertyWithCode:'DAun'] setTo:v];
}

- (double) lineSpacing
{
	id v = [[self propertyWithCode:'DAls'] get];
	return [v doubleValue];
}

- (void) setLineSpacing: (double) lineSpacing
{
	id v = [NSNumber numberWithDouble:lineSpacing];
	[[self propertyWithCode:'DAls'] setTo:v];
}

- (double) multipleLineHeight
{
	id v = [[self propertyWithCode:'DAlh'] get];
	return [v doubleValue];
}

- (void) setMultipleLineHeight: (double) multipleLineHeight
{
	id v = [NSNumber numberWithDouble:multipleLineHeight];
	[[self propertyWithCode:'DAlh'] setTo:v];
}

- (double) maximumLineHeight
{
	id v = [[self propertyWithCode:'DAmx'] get];
	return [v doubleValue];
}

- (void) setMaximumLineHeight: (double) maximumLineHeight
{
	id v = [NSNumber numberWithDouble:maximumLineHeight];
	[[self propertyWithCode:'DAmx'] setTo:v];
}

- (double) minimumLineHeight
{
	id v = [[self propertyWithCode:'DAmi'] get];
	return [v doubleValue];
}

- (void) setMinimumLineHeight: (double) minimumLineHeight
{
	id v = [NSNumber numberWithDouble:minimumLineHeight];
	[[self propertyWithCode:'DAmi'] setTo:v];
}

- (double) paragraphSpacing
{
	id v = [[self propertyWithCode:'DAps'] get];
	return [v doubleValue];
}

- (void) setParagraphSpacing: (double) paragraphSpacing
{
	id v = [NSNumber numberWithDouble:paragraphSpacing];
	[[self propertyWithCode:'DAps'] setTo:v];
}

- (NSInteger) superscript
{
	id v = [[self propertyWithCode:'DAss'] get];
	return [v integerValue];
}

- (void) setSuperscript: (NSInteger) superscript
{
	id v = [NSNumber numberWithInteger:superscript];
	[[self propertyWithCode:'DAss'] setTo:v];
}

- (double) tailIndent
{
	id v = [[self propertyWithCode:'DAti'] get];
	return [v doubleValue];
}

- (void) setTailIndent: (double) tailIndent
{
	id v = [NSNumber numberWithDouble:tailIndent];
	[[self propertyWithCode:'DAti'] setTo:v];
}

- (id) textContent
{
	return (id) [self propertyWithCode:'DNtc'];
}

- (void) setTextContent: (id) textContent
{
	[[self propertyWithCode:'DNtc'] setTo:textContent];
}

- (DEVONthinkTextAlignment) alignment
{
	id v = [[self propertyWithCode:'DAta'] get];
	return [v enumCodeValue];
}

- (void) setAlignment: (DEVONthinkTextAlignment) alignment
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:alignment];
	[[self propertyWithCode:'DAta'] setTo:v];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

@end


@implementation DEVONthinkParagraph(ExtendedTextSuite)


- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (double) baselineOffset
{
	id v = [[self propertyWithCode:'DAbo'] get];
	return [v doubleValue];
}

- (void) setBaselineOffset: (double) baselineOffset
{
	id v = [NSNumber numberWithDouble:baselineOffset];
	[[self propertyWithCode:'DAbo'] setTo:v];
}

- (id) background
{
	return (id) [self propertyWithCode:'DAbc'];
}

- (void) setBackground: (id) background
{
	[[self propertyWithCode:'DAbc'] setTo:background];
}

- (double) firstLineHeadIndent
{
	id v = [[self propertyWithCode:'DAfl'] get];
	return [v doubleValue];
}

- (void) setFirstLineHeadIndent: (double) firstLineHeadIndent
{
	id v = [NSNumber numberWithDouble:firstLineHeadIndent];
	[[self propertyWithCode:'DAfl'] setTo:v];
}

- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}

- (double) headIndent
{
	id v = [[self propertyWithCode:'DAhi'] get];
	return [v doubleValue];
}

- (void) setHeadIndent: (double) headIndent
{
	id v = [NSNumber numberWithDouble:headIndent];
	[[self propertyWithCode:'DAhi'] setTo:v];
}

- (BOOL) underlined
{
	id v = [[self propertyWithCode:'DAun'] get];
	return [v boolValue];
}

- (void) setUnderlined: (BOOL) underlined
{
	id v = [NSNumber numberWithBool:underlined];
	[[self propertyWithCode:'DAun'] setTo:v];
}

- (double) lineSpacing
{
	id v = [[self propertyWithCode:'DAls'] get];
	return [v doubleValue];
}

- (void) setLineSpacing: (double) lineSpacing
{
	id v = [NSNumber numberWithDouble:lineSpacing];
	[[self propertyWithCode:'DAls'] setTo:v];
}

- (double) multipleLineHeight
{
	id v = [[self propertyWithCode:'DAlh'] get];
	return [v doubleValue];
}

- (void) setMultipleLineHeight: (double) multipleLineHeight
{
	id v = [NSNumber numberWithDouble:multipleLineHeight];
	[[self propertyWithCode:'DAlh'] setTo:v];
}

- (double) maximumLineHeight
{
	id v = [[self propertyWithCode:'DAmx'] get];
	return [v doubleValue];
}

- (void) setMaximumLineHeight: (double) maximumLineHeight
{
	id v = [NSNumber numberWithDouble:maximumLineHeight];
	[[self propertyWithCode:'DAmx'] setTo:v];
}

- (double) minimumLineHeight
{
	id v = [[self propertyWithCode:'DAmi'] get];
	return [v doubleValue];
}

- (void) setMinimumLineHeight: (double) minimumLineHeight
{
	id v = [NSNumber numberWithDouble:minimumLineHeight];
	[[self propertyWithCode:'DAmi'] setTo:v];
}

- (double) paragraphSpacing
{
	id v = [[self propertyWithCode:'DAps'] get];
	return [v doubleValue];
}

- (void) setParagraphSpacing: (double) paragraphSpacing
{
	id v = [NSNumber numberWithDouble:paragraphSpacing];
	[[self propertyWithCode:'DAps'] setTo:v];
}

- (NSInteger) superscript
{
	id v = [[self propertyWithCode:'DAss'] get];
	return [v integerValue];
}

- (void) setSuperscript: (NSInteger) superscript
{
	id v = [NSNumber numberWithInteger:superscript];
	[[self propertyWithCode:'DAss'] setTo:v];
}

- (double) tailIndent
{
	id v = [[self propertyWithCode:'DAti'] get];
	return [v doubleValue];
}

- (void) setTailIndent: (double) tailIndent
{
	id v = [NSNumber numberWithDouble:tailIndent];
	[[self propertyWithCode:'DAti'] setTo:v];
}

- (id) textContent
{
	return (id) [self propertyWithCode:'DNtc'];
}

- (void) setTextContent: (id) textContent
{
	[[self propertyWithCode:'DNtc'] setTo:textContent];
}

- (DEVONthinkTextAlignment) alignment
{
	id v = [[self propertyWithCode:'DAta'] get];
	return [v enumCodeValue];
}

- (void) setAlignment: (DEVONthinkTextAlignment) alignment
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:alignment];
	[[self propertyWithCode:'DAta'] setTo:v];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

@end


@implementation DEVONthinkWord(ExtendedTextSuite)


- (SBElementArray *) attachments
{
	return [self elementArrayWithCode:'atts'];
}

- (SBElementArray *) attributeRuns
{
	return [self elementArrayWithCode:'catr'];
}

- (SBElementArray *) characters
{
	return [self elementArrayWithCode:'cha '];
}

- (SBElementArray *) paragraphs
{
	return [self elementArrayWithCode:'cpar'];
}

- (SBElementArray *) words
{
	return [self elementArrayWithCode:'cwor'];
}


- (double) baselineOffset
{
	id v = [[self propertyWithCode:'DAbo'] get];
	return [v doubleValue];
}

- (void) setBaselineOffset: (double) baselineOffset
{
	id v = [NSNumber numberWithDouble:baselineOffset];
	[[self propertyWithCode:'DAbo'] setTo:v];
}

- (id) background
{
	return (id) [self propertyWithCode:'DAbc'];
}

- (void) setBackground: (id) background
{
	[[self propertyWithCode:'DAbc'] setTo:background];
}

- (double) firstLineHeadIndent
{
	id v = [[self propertyWithCode:'DAfl'] get];
	return [v doubleValue];
}

- (void) setFirstLineHeadIndent: (double) firstLineHeadIndent
{
	id v = [NSNumber numberWithDouble:firstLineHeadIndent];
	[[self propertyWithCode:'DAfl'] setTo:v];
}

- (id) font
{
	return (id) [self propertyWithCode:'font'];
}

- (void) setFont: (id) font
{
	[[self propertyWithCode:'font'] setTo:font];
}

- (NSNumber *) size
{
	return [[self propertyWithCode:'ptsz'] get];
}

- (void) setSize: (NSNumber *) size
{
	[[self propertyWithCode:'ptsz'] setTo:size];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}

- (double) headIndent
{
	id v = [[self propertyWithCode:'DAhi'] get];
	return [v doubleValue];
}

- (void) setHeadIndent: (double) headIndent
{
	id v = [NSNumber numberWithDouble:headIndent];
	[[self propertyWithCode:'DAhi'] setTo:v];
}

- (BOOL) underlined
{
	id v = [[self propertyWithCode:'DAun'] get];
	return [v boolValue];
}

- (void) setUnderlined: (BOOL) underlined
{
	id v = [NSNumber numberWithBool:underlined];
	[[self propertyWithCode:'DAun'] setTo:v];
}

- (double) lineSpacing
{
	id v = [[self propertyWithCode:'DAls'] get];
	return [v doubleValue];
}

- (void) setLineSpacing: (double) lineSpacing
{
	id v = [NSNumber numberWithDouble:lineSpacing];
	[[self propertyWithCode:'DAls'] setTo:v];
}

- (double) multipleLineHeight
{
	id v = [[self propertyWithCode:'DAlh'] get];
	return [v doubleValue];
}

- (void) setMultipleLineHeight: (double) multipleLineHeight
{
	id v = [NSNumber numberWithDouble:multipleLineHeight];
	[[self propertyWithCode:'DAlh'] setTo:v];
}

- (double) maximumLineHeight
{
	id v = [[self propertyWithCode:'DAmx'] get];
	return [v doubleValue];
}

- (void) setMaximumLineHeight: (double) maximumLineHeight
{
	id v = [NSNumber numberWithDouble:maximumLineHeight];
	[[self propertyWithCode:'DAmx'] setTo:v];
}

- (double) minimumLineHeight
{
	id v = [[self propertyWithCode:'DAmi'] get];
	return [v doubleValue];
}

- (void) setMinimumLineHeight: (double) minimumLineHeight
{
	id v = [NSNumber numberWithDouble:minimumLineHeight];
	[[self propertyWithCode:'DAmi'] setTo:v];
}

- (double) paragraphSpacing
{
	id v = [[self propertyWithCode:'DAps'] get];
	return [v doubleValue];
}

- (void) setParagraphSpacing: (double) paragraphSpacing
{
	id v = [NSNumber numberWithDouble:paragraphSpacing];
	[[self propertyWithCode:'DAps'] setTo:v];
}

- (NSInteger) superscript
{
	id v = [[self propertyWithCode:'DAss'] get];
	return [v integerValue];
}

- (void) setSuperscript: (NSInteger) superscript
{
	id v = [NSNumber numberWithInteger:superscript];
	[[self propertyWithCode:'DAss'] setTo:v];
}

- (double) tailIndent
{
	id v = [[self propertyWithCode:'DAti'] get];
	return [v doubleValue];
}

- (void) setTailIndent: (double) tailIndent
{
	id v = [NSNumber numberWithDouble:tailIndent];
	[[self propertyWithCode:'DAti'] setTo:v];
}

- (id) textContent
{
	return (id) [self propertyWithCode:'DNtc'];
}

- (void) setTextContent: (id) textContent
{
	[[self propertyWithCode:'DNtc'] setTo:textContent];
}

- (DEVONthinkTextAlignment) alignment
{
	id v = [[self propertyWithCode:'DAta'] get];
	return [v enumCodeValue];
}

- (void) setAlignment: (DEVONthinkTextAlignment) alignment
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:alignment];
	[[self propertyWithCode:'DAta'] setTo:v];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

@end




/*
 * DEVONthink Suite
 */

@implementation DEVONthinkApplication(DEVONthinkSuite)


- (SBElementArray *) databases
{
	return [self elementArrayWithCode:'DTkb'];
}

- (SBElementArray *) thinkWindows
{
	return [self elementArrayWithCode:'thwi'];
}

- (SBElementArray *) mainWindows
{
	return [self elementArrayWithCode:'brws'];
}

- (SBElementArray *) documentWindows
{
	return [self elementArrayWithCode:'cowi'];
}

- (SBElementArray *) selectedRecords
{
	return [self elementArrayWithCode:'DTsd'];
}


- (NSInteger) batesNumber
{
	id v = [[self propertyWithCode:'BTbn'] get];
	return [v integerValue];
}

- (void) setBatesNumber: (NSInteger) batesNumber
{
	id v = [NSNumber numberWithInteger:batesNumber];
	[[self propertyWithCode:'BTbn'] setTo:v];
}

- (BOOL) cancelledProgress
{
	id v = [[self propertyWithCode:'DTca'] get];
	return [v boolValue];
}

- (id) currentChatEngine
{
	return (id) [self propertyWithCode:'DTci'];
}

- (id) currentChatModel
{
	return (id) [self propertyWithCode:'DTcd'];
}

- (id) currentGroup
{
	return (id) [self propertyWithCode:'DTcg'];
}

- (id) currentWorkspace
{
	return (id) [self propertyWithCode:'DTcw'];
}

- (id) currentDatabase
{
	return (id) [self propertyWithCode:'DTcu'];
}

- (id) contentRecord
{
	return (id) [self propertyWithCode:'DTdr'];
}

- (id) inbox
{
	return (id) [self propertyWithCode:'DTib'];
}

- (id) incomingGroup
{
	return (id) [self propertyWithCode:'DTig'];
}

- (id) labelNames
{
	return (id) [self propertyWithCode:'DTln'];
}

- (id) lastDownloadedResponse
{
	return (id) [self propertyWithCode:'DTlr'];
}

- (id) lastDownloadedURL
{
	return (id) [self propertyWithCode:'DTld'];
}

- (id) preferredImportDestination
{
	return (id) [self propertyWithCode:'DTid'];
}

- (id) readingList
{
	return (id) [self propertyWithCode:'DTrl'];
}

- (id) selection
{
	return (id) [self propertyWithCode:'DTsl'];
}

- (BOOL) strictDuplicateRecognition
{
	id v = [[self propertyWithCode:'DTrg'] get];
	return [v boolValue];
}

- (void) setStrictDuplicateRecognition: (BOOL) strictDuplicateRecognition
{
	id v = [NSNumber numberWithBool:strictDuplicateRecognition];
	[[self propertyWithCode:'DTrg'] setTo:v];
}

- (id) workspaces
{
	return (id) [self propertyWithCode:'DTws'];
}

@end


@implementation DEVONthinkDatabase

- (SBElementArray *) contents
{
	return [self elementArrayWithCode:'DTcn'];
}

- (SBElementArray *) parents
{
	return [self elementArrayWithCode:'DTpr'];
}

- (SBElementArray *) smartParents
{
	return [self elementArrayWithCode:'DTsx'];
}

- (SBElementArray *) tagGroups
{
	return [self elementArrayWithCode:'DTta'];
}


- (NSInteger) id
{
	id v = [[self propertyWithCode:'ID  '] get];
	return [v integerValue];
}

- (id) uuid
{
	return (id) [self propertyWithCode:'UUID'];
}

- (id) annotationsGroup
{
	return (id) [self propertyWithCode:'DTas'];
}

- (id) comment
{
	return (id) [self propertyWithCode:'DTco'];
}

- (void) setComment: (id) comment
{
	[[self propertyWithCode:'DTco'] setTo:comment];
}

- (id) currentGroup
{
	return (id) [self propertyWithCode:'DTcg'];
}

- (id) incomingGroup
{
	return (id) [self propertyWithCode:'DTig'];
}

- (BOOL) encrypted
{
	id v = [[self propertyWithCode:'DTey'] get];
	return [v boolValue];
}

- (BOOL) revisionProof
{
	id v = [[self propertyWithCode:'DTey'] get];
	return [v boolValue];
}

- (BOOL) readOnly
{
	id v = [[self propertyWithCode:'DTry'] get];
	return [v boolValue];
}

- (BOOL) SpotlightIndexing
{
	id v = [[self propertyWithCode:'DTsi'] get];
	return [v boolValue];
}

- (void) setSpotlightIndexing: (BOOL) SpotlightIndexing
{
	id v = [NSNumber numberWithBool:SpotlightIndexing];
	[[self propertyWithCode:'DTsi'] setTo:v];
}

- (BOOL) versioning
{
	id v = [[self propertyWithCode:'DTvs'] get];
	return [v boolValue];
}

- (void) setVersioning: (BOOL) versioning
{
	id v = [NSNumber numberWithBool:versioning];
	[[self propertyWithCode:'DTvs'] setTo:v];
}

- (NSString *) name
{
	return [[self propertyWithCode:'pnam'] get];
}

- (void) setName: (NSString *) name
{
	[[self propertyWithCode:'pnam'] setTo:name];
}

- (id) filename
{
	return (id) [self propertyWithCode:'DTfe'];
}

- (id) path
{
	return (id) [self propertyWithCode:'ppth'];
}

- (id) root
{
	return (id) [self propertyWithCode:'DTro'];
}

- (id) tagsGroup
{
	return (id) [self propertyWithCode:'DTts'];
}

- (id) trashGroup
{
	return (id) [self propertyWithCode:'DTtg'];
}

- (id) versionsGroup
{
	return (id) [self propertyWithCode:'DTvg'];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkRecord

- (SBElementArray *) children
{
	return [self elementArrayWithCode:'DTch'];
}

- (SBElementArray *) incomingReferences
{
	return [self elementArrayWithCode:'DTic'];
}

- (SBElementArray *) incomingWikiReferences
{
	return [self elementArrayWithCode:'DTwr'];
}

- (SBElementArray *) outgoingReferences
{
	return [self elementArrayWithCode:'DToc'];
}

- (SBElementArray *) outgoingWikiReferences
{
	return [self elementArrayWithCode:'DTow'];
}

- (SBElementArray *) parents
{
	return [self elementArrayWithCode:'DTpr'];
}


- (NSInteger) id
{
	id v = [[self propertyWithCode:'ID  '] get];
	return [v integerValue];
}

- (id) MIMEType
{
	return (id) [self propertyWithCode:'DTmt'];
}

- (id) uuid
{
	return (id) [self propertyWithCode:'UUID'];
}

- (id) additionDate
{
	return (id) [self propertyWithCode:'DTad'];
}

- (id) aliases
{
	return (id) [self propertyWithCode:'DTal'];
}

- (void) setAliases: (id) aliases
{
	[[self propertyWithCode:'DTal'] setTo:aliases];
}

- (double) altitude
{
	id v = [[self propertyWithCode:'galt'] get];
	return [v doubleValue];
}

- (void) setAltitude: (double) altitude
{
	id v = [NSNumber numberWithDouble:altitude];
	[[self propertyWithCode:'galt'] setTo:v];
}

- (id) annotation
{
	return (id) [self propertyWithCode:'DTan'];
}

- (void) setAnnotation: (id) annotation
{
	[[self propertyWithCode:'DTan'] setTo:annotation];
}

- (NSInteger) annotationCount
{
	id v = [[self propertyWithCode:'DTna'] get];
	return [v integerValue];
}

- (id) attachedScript
{
	return (id) [self propertyWithCode:'DTac'];
}

- (void) setAttachedScript: (id) attachedScript
{
	[[self propertyWithCode:'DTac'] setTo:attachedScript];
}

- (NSInteger) attachmentCount
{
	id v = [[self propertyWithCode:'DTnt'] get];
	return [v integerValue];
}

- (id) attributesChangeDate
{
	return (id) [self propertyWithCode:'DTar'];
}

- (void) setAttributesChangeDate: (id) attributesChangeDate
{
	[[self propertyWithCode:'DTar'] setTo:attributesChangeDate];
}

- (NSInteger) batesNumber
{
	id v = [[self propertyWithCode:'BTbn'] get];
	return [v integerValue];
}

- (void) setBatesNumber: (NSInteger) batesNumber
{
	id v = [NSNumber numberWithInteger:batesNumber];
	[[self propertyWithCode:'BTbn'] setTo:v];
}

- (NSArray<NSArray *> *) cells
{
	return [[self propertyWithCode:'DTce'] get];
}

- (void) setCells: (NSArray<NSArray *> *) cells
{
	[[self propertyWithCode:'DTce'] setTo:cells];
}

- (NSInteger) characterCount
{
	id v = [[self propertyWithCode:'DTcc'] get];
	return [v integerValue];
}

- (id) color
{
	return (id) [self propertyWithCode:'colr'];
}

- (void) setColor: (id) color
{
	[[self propertyWithCode:'colr'] setTo:color];
}

- (id) columns
{
	return (id) [self propertyWithCode:'DTcl'];
}

- (id) comment
{
	return (id) [self propertyWithCode:'DTco'];
}

- (void) setComment: (id) comment
{
	[[self propertyWithCode:'DTco'] setTo:comment];
}

- (id) contentHash
{
	return (id) [self propertyWithCode:'DTdi'];
}

- (id) creationDate
{
	return (id) [self propertyWithCode:'DTcr'];
}

- (void) setCreationDate: (id) creationDate
{
	[[self propertyWithCode:'DTcr'] setTo:creationDate];
}

- (id) customMetaData
{
	return (id) [self propertyWithCode:'DTcm'];
}

- (void) setCustomMetaData: (id) customMetaData
{
	[[self propertyWithCode:'DTcm'] setTo:customMetaData];
}

- (id) data
{
	return (id) [self propertyWithCode:'tdta'];
}

- (void) setData: (id) data
{
	[[self propertyWithCode:'tdta'] setTo:data];
}

- (id) database
{
	return (id) [self propertyWithCode:'DTkb'];
}

- (id) date
{
	return (id) [self propertyWithCode:'ldt '];
}

- (void) setDate: (id) date
{
	[[self propertyWithCode:'ldt '] setTo:date];
}

- (id) digitalObjectIdentifier
{
	return (id) [self propertyWithCode:'Ddoi'];
}

- (NSArray<NSNumber *> *) dimensions
{
	return [[self propertyWithCode:'pdim'] get];
}

- (id) documentAmount
{
	return (id) [self propertyWithCode:'DTdm'];
}

- (id) documentDate
{
	return (id) [self propertyWithCode:'DTdd'];
}

- (id) allDocumentDates
{
	return (id) [self propertyWithCode:'Dadd'];
}

- (id) documentName
{
	return (id) [self propertyWithCode:'DTpn'];
}

- (NSNumber *) dpi
{
	return [[self propertyWithCode:'DTdp'] get];
}

- (id) duplicates
{
	return (id) [self propertyWithCode:'DTdu'];
}

- (double) duration
{
	id v = [[self propertyWithCode:'pdur'] get];
	return [v doubleValue];
}

- (BOOL) encrypted
{
	id v = [[self propertyWithCode:'DTey'] get];
	return [v boolValue];
}

- (BOOL) excludeFromChat
{
	id v = [[self propertyWithCode:'DTxi'] get];
	return [v boolValue];
}

- (void) setExcludeFromChat: (BOOL) excludeFromChat
{
	id v = [NSNumber numberWithBool:excludeFromChat];
	[[self propertyWithCode:'DTxi'] setTo:v];
}

- (BOOL) excludeFromClassification
{
	id v = [[self propertyWithCode:'DTxc'] get];
	return [v boolValue];
}

- (void) setExcludeFromClassification: (BOOL) excludeFromClassification
{
	id v = [NSNumber numberWithBool:excludeFromClassification];
	[[self propertyWithCode:'DTxc'] setTo:v];
}

- (BOOL) excludeFromSearch
{
	id v = [[self propertyWithCode:'DTxs'] get];
	return [v boolValue];
}

- (void) setExcludeFromSearch: (BOOL) excludeFromSearch
{
	id v = [NSNumber numberWithBool:excludeFromSearch];
	[[self propertyWithCode:'DTxs'] setTo:v];
}

- (BOOL) excludeFromSeeAlso
{
	id v = [[self propertyWithCode:'DTxa'] get];
	return [v boolValue];
}

- (void) setExcludeFromSeeAlso: (BOOL) excludeFromSeeAlso
{
	id v = [NSNumber numberWithBool:excludeFromSeeAlso];
	[[self propertyWithCode:'DTxa'] setTo:v];
}

- (BOOL) excludeFromTagging
{
	id v = [[self propertyWithCode:'DTxt'] get];
	return [v boolValue];
}

- (void) setExcludeFromTagging: (BOOL) excludeFromTagging
{
	id v = [NSNumber numberWithBool:excludeFromTagging];
	[[self propertyWithCode:'DTxt'] setTo:v];
}

- (BOOL) excludeFromWikiLinking
{
	id v = [[self propertyWithCode:'DTxw'] get];
	return [v boolValue];
}

- (void) setExcludeFromWikiLinking: (BOOL) excludeFromWikiLinking
{
	id v = [NSNumber numberWithBool:excludeFromWikiLinking];
	[[self propertyWithCode:'DTxw'] setTo:v];
}

- (id) filename
{
	return (id) [self propertyWithCode:'DTfe'];
}

- (BOOL) flag
{
	id v = [[self propertyWithCode:'DTst'] get];
	return [v boolValue];
}

- (void) setFlag: (BOOL) flag
{
	id v = [NSNumber numberWithBool:flag];
	[[self propertyWithCode:'DTst'] setTo:v];
}

- (id) geolocation
{
	return (id) [self propertyWithCode:'gloc'];
}

- (void) setGeolocation: (id) geolocation
{
	[[self propertyWithCode:'gloc'] setTo:geolocation];
}

- (NSNumber *) height
{
	return [[self propertyWithCode:'phit'] get];
}

- (id) image
{
	return (id) [self propertyWithCode:'imaA'];
}

- (void) setImage: (id) image
{
	[[self propertyWithCode:'imaA'] setTo:image];
}

- (BOOL) indexed
{
	id v = [[self propertyWithCode:'DTix'] get];
	return [v boolValue];
}

- (id) internationalStandardBookNumber
{
	return (id) [self propertyWithCode:'isbn'];
}

- (double) interval
{
	id v = [[self propertyWithCode:'DTiv'] get];
	return [v doubleValue];
}

- (void) setInterval: (double) interval
{
	id v = [NSNumber numberWithDouble:interval];
	[[self propertyWithCode:'DTiv'] setTo:v];
}

- (id) kind
{
	return (id) [self propertyWithCode:'DTki'];
}

- (NSInteger) label
{
	id v = [[self propertyWithCode:'DTla'] get];
	return [v integerValue];
}

- (void) setLabel: (NSInteger) label
{
	id v = [NSNumber numberWithInteger:label];
	[[self propertyWithCode:'DTla'] setTo:v];
}

- (id) language
{
	return (id) [self propertyWithCode:'lang'];
}

- (double) latitude
{
	id v = [[self propertyWithCode:'glat'] get];
	return [v doubleValue];
}

- (void) setLatitude: (double) latitude
{
	id v = [NSNumber numberWithDouble:latitude];
	[[self propertyWithCode:'glat'] setTo:v];
}

- (id) location
{
	return (id) [self propertyWithCode:'DTlo'];
}

- (id) locationGroup
{
	return (id) [self propertyWithCode:'DTlg'];
}

- (id) locationWithName
{
	return (id) [self propertyWithCode:'DTlx'];
}

- (BOOL) locking
{
	id v = [[self propertyWithCode:'DTlc'] get];
	return [v boolValue];
}

- (void) setLocking: (BOOL) locking
{
	id v = [NSNumber numberWithBool:locking];
	[[self propertyWithCode:'DTlc'] setTo:v];
}

- (double) longitude
{
	id v = [[self propertyWithCode:'glon'] get];
	return [v doubleValue];
}

- (void) setLongitude: (double) longitude
{
	id v = [NSNumber numberWithDouble:longitude];
	[[self propertyWithCode:'glon'] setTo:v];
}

- (id) markdownSource
{
	return (id) [self propertyWithCode:'mkds'];
}

- (id) metaData
{
	return (id) [self propertyWithCode:'mtdt'];
}

- (id) modificationDate
{
	return (id) [self propertyWithCode:'DTmo'];
}

- (void) setModificationDate: (id) modificationDate
{
	[[self propertyWithCode:'DTmo'] setTo:modificationDate];
}

- (NSString *) name
{
	return [[self propertyWithCode:'pnam'] get];
}

- (void) setName: (NSString *) name
{
	[[self propertyWithCode:'pnam'] setTo:name];
}

- (id) nameWithoutDate
{
	return (id) [self propertyWithCode:'DTns'];
}

- (id) nameWithoutExtension
{
	return (id) [self propertyWithCode:'DTnw'];
}

- (id) newestDocumentDate
{
	return (id) [self propertyWithCode:'Dndd'];
}

- (NSInteger) numberOfDuplicates
{
	id v = [[self propertyWithCode:'DTnd'] get];
	return [v integerValue];
}

- (NSInteger) numberOfHits
{
	id v = [[self propertyWithCode:'DTnh'] get];
	return [v integerValue];
}

- (void) setNumberOfHits: (NSInteger) numberOfHits
{
	id v = [NSNumber numberWithInteger:numberOfHits];
	[[self propertyWithCode:'DTnh'] setTo:v];
}

- (NSInteger) numberOfReplicants
{
	id v = [[self propertyWithCode:'DTnr'] get];
	return [v integerValue];
}

- (id) oldestDocumentDate
{
	return (id) [self propertyWithCode:'Dodd'];
}

- (NSString *) originalName
{
	return [[self propertyWithCode:'onam'] get];
}

- (id) openingDate
{
	return (id) [self propertyWithCode:'DTon'];
}

- (NSInteger) pageCount
{
	id v = [[self propertyWithCode:'DTpc'] get];
	return [v integerValue];
}

- (id) paginatedPDF
{
	return (id) [self propertyWithCode:'pgPD'];
}

- (id) path
{
	return (id) [self propertyWithCode:'ppth'];
}

- (void) setPath: (id) path
{
	[[self propertyWithCode:'ppth'] setTo:path];
}

- (BOOL) pending
{
	id v = [[self propertyWithCode:'DTpd'] get];
	return [v boolValue];
}

- (id) plainText
{
	return (id) [self propertyWithCode:'DTpl'];
}

- (void) setPlainText: (id) plainText
{
	[[self propertyWithCode:'DTpl'] setTo:plainText];
}

- (id) proposedFilename
{
	return (id) [self propertyWithCode:'DTfn'];
}

- (NSInteger) rating
{
	id v = [[self propertyWithCode:'DTrt'] get];
	return [v integerValue];
}

- (void) setRating: (NSInteger) rating
{
	id v = [NSNumber numberWithInteger:rating];
	[[self propertyWithCode:'DTrt'] setTo:v];
}

- (DEVONthinkDataType) recordType
{
	id v = [[self propertyWithCode:'DTrp'] get];
	return [v enumCodeValue];
}

- (id) referenceURL
{
	return (id) [self propertyWithCode:'rURL'];
}

- (id) reminder
{
	return (id) [self propertyWithCode:'DTrm'];
}

- (void) setReminder: (id) reminder
{
	[[self propertyWithCode:'DTrm'] setTo:reminder];
}

- (id) richText
{
	return (id) [self propertyWithCode:'ctxt'];
}

- (void) setRichText: (id) richText
{
	[[self propertyWithCode:'ctxt'] setTo:richText];
}

- (double) score
{
	id v = [[self propertyWithCode:'DTso'] get];
	return [v doubleValue];
}

- (NSInteger) size
{
	id v = [[self propertyWithCode:'ptsz'] get];
	return [v integerValue];
}

- (id) source
{
	return (id) [self propertyWithCode:'conT'];
}

- (void) setSource: (id) source
{
	[[self propertyWithCode:'conT'] setTo:source];
}

- (DEVONthinkTagType) tagType
{
	id v = [[self propertyWithCode:'DTtt'] get];
	return [v enumCodeValue];
}

- (id) tags
{
	return (id) [self propertyWithCode:'tags'];
}

- (void) setTags: (id) tags
{
	[[self propertyWithCode:'tags'] setTo:tags];
}

- (id) thumbnail
{
	return (id) [self propertyWithCode:'DTth'];
}

- (void) setThumbnail: (id) thumbnail
{
	[[self propertyWithCode:'DTth'] setTo:thumbnail];
}

- (NSArray<NSString *> *) unlinkedWikiLinks
{
	return [[self propertyWithCode:'DTuw'] get];
}

- (void) setUnlinkedWikiLinks: (NSArray<NSString *> *) unlinkedWikiLinks
{
	[[self propertyWithCode:'DTuw'] setTo:unlinkedWikiLinks];
}

- (BOOL) unread
{
	id v = [[self propertyWithCode:'DTur'] get];
	return [v boolValue];
}

- (void) setUnread: (BOOL) unread
{
	id v = [NSNumber numberWithBool:unread];
	[[self propertyWithCode:'DTur'] setTo:v];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

- (id) webArchive
{
	return (id) [self propertyWithCode:'DNav'];
}

- (NSNumber *) width
{
	return [[self propertyWithCode:'pwid'] get];
}

- (NSInteger) wordCount
{
	id v = [[self propertyWithCode:'DTwc'] get];
	return [v integerValue];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkChild

@end


@implementation DEVONthinkContent

@end


@implementation DEVONthinkIncomingReference

@end


@implementation DEVONthinkIncomingWikiReference

@end


@implementation DEVONthinkOutgoingReference

@end


@implementation DEVONthinkOutgoingWikiReference

@end


@implementation DEVONthinkParent

@end


@implementation DEVONthinkReminder

- (DEVONthinkReminderAlarm) alarm
{
	id v = [[self propertyWithCode:'DRal'] get];
	return [v enumCodeValue];
}

- (void) setAlarm: (DEVONthinkReminderAlarm) alarm
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:alarm];
	[[self propertyWithCode:'DRal'] setTo:v];
}

- (id) alarmString
{
	return (id) [self propertyWithCode:'DRas'];
}

- (void) setAlarmString: (id) alarmString
{
	[[self propertyWithCode:'DRas'] setTo:alarmString];
}

- (DEVONthinkReminderDay) dayOfWeek
{
	id v = [[self propertyWithCode:'DRdw'] get];
	return [v enumCodeValue];
}

- (void) setDayOfWeek: (DEVONthinkReminderDay) dayOfWeek
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:dayOfWeek];
	[[self propertyWithCode:'DRdw'] setTo:v];
}

- (id) dueDate
{
	return (id) [self propertyWithCode:'DRdu'];
}

- (void) setDueDate: (id) dueDate
{
	[[self propertyWithCode:'DRdu'] setTo:dueDate];
}

- (NSInteger) interval
{
	id v = [[self propertyWithCode:'DTiv'] get];
	return [v integerValue];
}

- (void) setInterval: (NSInteger) interval
{
	id v = [NSNumber numberWithInteger:interval];
	[[self propertyWithCode:'DTiv'] setTo:v];
}

- (NSInteger) masc
{
	id v = [[self propertyWithCode:'DRmc'] get];
	return [v integerValue];
}

- (void) setMasc: (NSInteger) masc
{
	id v = [NSNumber numberWithInteger:masc];
	[[self propertyWithCode:'DRmc'] setTo:v];
}

- (DEVONthinkReminderSchedule) schedule
{
	id v = [[self propertyWithCode:'DRsc'] get];
	return [v enumCodeValue];
}

- (void) setSchedule: (DEVONthinkReminderSchedule) schedule
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:schedule];
	[[self propertyWithCode:'DRsc'] setTo:v];
}

- (DEVONthinkReminderWeek) weekOfMonth
{
	id v = [[self propertyWithCode:'DRnw'] get];
	return [v enumCodeValue];
}

- (void) setWeekOfMonth: (DEVONthinkReminderWeek) weekOfMonth
{
	id v = [NSAppleEventDescriptor descriptorWithEnumCode:weekOfMonth];
	[[self propertyWithCode:'DRnw'] setTo:v];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkSelectedRecord

@end


@implementation DEVONthinkSmartParent

- (BOOL) excludeSubgroups
{
	id v = [[self propertyWithCode:'DTqx'] get];
	return [v boolValue];
}

- (void) setExcludeSubgroups: (BOOL) excludeSubgroups
{
	id v = [NSNumber numberWithBool:excludeSubgroups];
	[[self propertyWithCode:'DTqx'] setTo:v];
}

- (BOOL) highlightOccurrences
{
	id v = [[self propertyWithCode:'DTqh'] get];
	return [v boolValue];
}

- (void) setHighlightOccurrences: (BOOL) highlightOccurrences
{
	id v = [NSNumber numberWithBool:highlightOccurrences];
	[[self propertyWithCode:'DTqh'] setTo:v];
}

- (id) searchGroup
{
	return (id) [self propertyWithCode:'DTqg'];
}

- (void) setSearchGroup: (id) searchGroup
{
	[[self propertyWithCode:'DTqg'] setTo:searchGroup];
}

- (id) searchPredicates
{
	return (id) [self propertyWithCode:'DTqt'];
}

- (void) setSearchPredicates: (id) searchPredicates
{
	[[self propertyWithCode:'DTqt'] setTo:searchPredicates];
}


@end


@implementation DEVONthinkTagGroup

@end


@implementation DEVONthinkTab

- (NSInteger) id
{
	id v = [[self propertyWithCode:'ID  '] get];
	return [v integerValue];
}

- (id) PDF
{
	return (id) [self propertyWithCode:'pPDF'];
}

- (id) webArchive
{
	return (id) [self propertyWithCode:'DNav'];
}

- (NSInteger) currentLine
{
	id v = [[self propertyWithCode:'DTli'] get];
	return [v integerValue];
}

- (id) currentMovieFrame
{
	return (id) [self propertyWithCode:'DTmf'];
}

- (double) currentTime
{
	id v = [[self propertyWithCode:'DTti'] get];
	return [v doubleValue];
}

- (void) setCurrentTime: (double) currentTime
{
	id v = [NSNumber numberWithDouble:currentTime];
	[[self propertyWithCode:'DTti'] setTo:v];
}

- (NSInteger) currentPage
{
	id v = [[self propertyWithCode:'DTpe'] get];
	return [v integerValue];
}

- (void) setCurrentPage: (NSInteger) currentPage
{
	id v = [NSNumber numberWithInteger:currentPage];
	[[self propertyWithCode:'DTpe'] setTo:v];
}

- (id) database
{
	return (id) [self propertyWithCode:'DTkb'];
}

- (id) contentRecord
{
	return (id) [self propertyWithCode:'DTdr'];
}

- (BOOL) loading
{
	id v = [[self propertyWithCode:'iLdg'] get];
	return [v boolValue];
}

- (NSInteger) numberOfColumns
{
	id v = [[self propertyWithCode:'DTcs'] get];
	return [v integerValue];
}

- (NSInteger) numberOfRows
{
	id v = [[self propertyWithCode:'DTrw'] get];
	return [v integerValue];
}

- (id) paginatedPDF
{
	return (id) [self propertyWithCode:'pgPD'];
}

- (id) referenceURL
{
	return (id) [self propertyWithCode:'rURL'];
}

- (NSInteger) selectedColumn
{
	id v = [[self propertyWithCode:'DTsn'] get];
	return [v integerValue];
}

- (void) setSelectedColumn: (NSInteger) selectedColumn
{
	id v = [NSNumber numberWithInteger:selectedColumn];
	[[self propertyWithCode:'DTsn'] setTo:v];
}

- (NSArray<NSNumber *> *) selectedColumns
{
	return [[self propertyWithCode:'DTsc'] get];
}

- (NSInteger) selectedRow
{
	id v = [[self propertyWithCode:'DTsr'] get];
	return [v integerValue];
}

- (void) setSelectedRow: (NSInteger) selectedRow
{
	id v = [NSNumber numberWithInteger:selectedRow];
	[[self propertyWithCode:'DTsr'] setTo:v];
}

- (NSArray<NSNumber *> *) selectedRows
{
	return [[self propertyWithCode:'DTsw'] get];
}

- (id) source
{
	return (id) [self propertyWithCode:'conT'];
}

- (id) thinkWindow
{
	return (id) [self propertyWithCode:'thwi'];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

- (id) selectedText
{
	return (id) [self propertyWithCode:'subs'];
}

- (void) setSelectedText: (id) selectedText
{
	[[self propertyWithCode:'subs'] setTo:selectedText];
}

- (id) plainText
{
	return (id) [self propertyWithCode:'DTpl'];
}

- (id) richText
{
	return (id) [self propertyWithCode:'ctxt'];
}

- (void) setRichText: (id) richText
{
	[[self propertyWithCode:'ctxt'] setTo:richText];
}



- (void) closeSaving:(DEVONthinkSaveOptions)saving
{
	[self sendEvent:'core' id:'clos' parameters:'savo', [NSAppleEventDescriptor descriptorWithEnumCode:saving], 0];
}

- (void) save
{
	[self sendEvent:'core' id:'save' parameters:0];
}

- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog
{
	[self sendEvent:'aevt' id:'pdoc' parameters:'prdt', withProperties, 'pdlg', [NSNumber numberWithBool:printDialog], 0];
}

- (void) bold
{
	[self sendEvent:'OETS' id:'DAbo' parameters:0];
}

- (void) italicize
{
	[self sendEvent:'OETS' id:'DAit' parameters:0];
}

- (void) plain
{
	[self sendEvent:'OETS' id:'DApl' parameters:0];
}

- (void) reformat
{
	[self sendEvent:'OETS' id:'DArf' parameters:0];
}

- (void) scrollToVisible
{
	[self sendEvent:'OETS' id:'DAsv' parameters:0];
}

- (void) strike
{
	[self sendEvent:'OETS' id:'DAst' parameters:0];
}

- (void) unbold
{
	[self sendEvent:'OETS' id:'DAub' parameters:0];
}

- (void) underline
{
	[self sendEvent:'OETS' id:'DAun' parameters:0];
}

- (void) unitalicize
{
	[self sendEvent:'OETS' id:'DAui' parameters:0];
}

- (void) unstrike
{
	[self sendEvent:'OETS' id:'DAus' parameters:0];
}

- (void) ununderline
{
	[self sendEvent:'OETS' id:'DAuu' parameters:0];
}

- (BOOL) addRowCells:(NSArray<NSString *> *)cells
{
	id result__ = [self sendEvent:'DTpa' id:'cd63' parameters:'DTce', cells, 0];
	return [result__ boolValue];
}

- (BOOL) deleteRowAtPosition:(NSInteger)position
{
	id result__ = [self sendEvent:'DTpa' id:'cd64' parameters:'kpos', [NSNumber numberWithInteger:position], 0];
	return [result__ boolValue];
}

- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt
{
	id result__ = [self sendEvent:'DTpa' id:'cdf0' parameters:'pnam', name, 'Drol', role, 'Dpro', prompt, 0];
	return result__;
}

- (id) getCellAtColumn:(id)column row:(NSInteger)row
{
	id result__ = [self sendEvent:'DTpa' id:'cd61' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 0];
	return result__;
}

- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to
{
	id result__ = [self sendEvent:'DTpa' id:'cd62' parameters:'DTcx', column, 'DTrx', [NSNumber numberWithInteger:row], 'DTto', to, 0];
	return [result__ boolValue];
}

@end


@implementation DEVONthinkThinkWindow

- (SBElementArray *) tabs
{
	return [self elementArrayWithCode:'thtb'];
}


- (id) PDF
{
	return (id) [self propertyWithCode:'pPDF'];
}

- (id) webArchive
{
	return (id) [self propertyWithCode:'DNav'];
}

- (NSInteger) currentLine
{
	id v = [[self propertyWithCode:'DTli'] get];
	return [v integerValue];
}

- (id) currentMovieFrame
{
	return (id) [self propertyWithCode:'DTmf'];
}

- (double) currentTime
{
	id v = [[self propertyWithCode:'DTti'] get];
	return [v doubleValue];
}

- (void) setCurrentTime: (double) currentTime
{
	id v = [NSNumber numberWithDouble:currentTime];
	[[self propertyWithCode:'DTti'] setTo:v];
}

- (NSInteger) currentPage
{
	id v = [[self propertyWithCode:'DTpe'] get];
	return [v integerValue];
}

- (void) setCurrentPage: (NSInteger) currentPage
{
	id v = [NSNumber numberWithInteger:currentPage];
	[[self propertyWithCode:'DTpe'] setTo:v];
}

- (id) currentTab
{
	return (id) [self propertyWithCode:'cutb'];
}

- (void) setCurrentTab: (id) currentTab
{
	[[self propertyWithCode:'cutb'] setTo:currentTab];
}

- (id) database
{
	return (id) [self propertyWithCode:'DTkb'];
}

- (id) contentRecord
{
	return (id) [self propertyWithCode:'DTdr'];
}

- (BOOL) loading
{
	id v = [[self propertyWithCode:'iLdg'] get];
	return [v boolValue];
}

- (NSInteger) numberOfColumns
{
	id v = [[self propertyWithCode:'DTcs'] get];
	return [v integerValue];
}

- (NSInteger) numberOfRows
{
	id v = [[self propertyWithCode:'DTrw'] get];
	return [v integerValue];
}

- (id) paginatedPDF
{
	return (id) [self propertyWithCode:'pgPD'];
}

- (id) referenceURL
{
	return (id) [self propertyWithCode:'rURL'];
}

- (NSInteger) selectedColumn
{
	id v = [[self propertyWithCode:'DTsn'] get];
	return [v integerValue];
}

- (void) setSelectedColumn: (NSInteger) selectedColumn
{
	id v = [NSNumber numberWithInteger:selectedColumn];
	[[self propertyWithCode:'DTsn'] setTo:v];
}

- (NSArray<NSNumber *> *) selectedColumns
{
	return [[self propertyWithCode:'DTsc'] get];
}

- (NSInteger) selectedRow
{
	id v = [[self propertyWithCode:'DTsr'] get];
	return [v integerValue];
}

- (void) setSelectedRow: (NSInteger) selectedRow
{
	id v = [NSNumber numberWithInteger:selectedRow];
	[[self propertyWithCode:'DTsr'] setTo:v];
}

- (NSArray<NSNumber *> *) selectedRows
{
	return [[self propertyWithCode:'DTsw'] get];
}

- (id) source
{
	return (id) [self propertyWithCode:'conT'];
}

- (id) URL
{
	return (id) [self propertyWithCode:'pURL'];
}

- (void) setURL: (id) URL
{
	[[self propertyWithCode:'pURL'] setTo:URL];
}

- (id) selectedText
{
	return (id) [self propertyWithCode:'subs'];
}

- (void) setSelectedText: (id) selectedText
{
	[[self propertyWithCode:'subs'] setTo:selectedText];
}

- (id) plainText
{
	return (id) [self propertyWithCode:'DTpl'];
}

- (id) richText
{
	return (id) [self propertyWithCode:'ctxt'];
}

- (void) setRichText: (id) richText
{
	[[self propertyWithCode:'ctxt'] setTo:richText];
}


@end


@implementation DEVONthinkDocumentWindow

- (id) contentRecord
{
	return (id) [self propertyWithCode:'DTdr'];
}

- (void) setContentRecord: (id) contentRecord
{
	[[self propertyWithCode:'DTdr'] setTo:contentRecord];
}


@end


@implementation DEVONthinkMainWindow

- (SBElementArray *) selectedRecords
{
	return [self elementArrayWithCode:'DTsd'];
}


- (id) searchResults
{
	return (id) [self propertyWithCode:'DTru'];
}

- (void) setSearchResults: (id) searchResults
{
	[[self propertyWithCode:'DTru'] setTo:searchResults];
}

- (id) root
{
	return (id) [self propertyWithCode:'DTro'];
}

- (void) setRoot: (id) root
{
	[[self propertyWithCode:'DTro'] setTo:root];
}

- (id) searchQuery
{
	return (id) [self propertyWithCode:'DTss'];
}

- (void) setSearchQuery: (id) searchQuery
{
	[[self propertyWithCode:'DTss'] setTo:searchQuery];
}

- (id) selection
{
	return (id) [self propertyWithCode:'DTsl'];
}

- (void) setSelection: (id) selection
{
	[[self propertyWithCode:'DTsl'] setTo:selection];
}


@end


