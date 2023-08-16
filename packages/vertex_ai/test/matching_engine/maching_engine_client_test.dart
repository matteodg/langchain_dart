// ignore_for_file: avoid_print
@TestOn('vm')
library; // Uses dart:io

import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:test/test.dart';
import 'package:vertex_ai/vertex_ai.dart';

void main() async {
  final authClient = await _getAuthenticatedClient();
  final marchingEngine = VertexAIMatchingEngineClient(
    authHttpClient: authClient,
    project: Platform.environment['VERTEX_AI_PROJECT_ID']!,
    location: 'europe-west1',
  );

  group('VertexAIMatchingEngineClient management tests', skip: true, () {
    test('Test create index', () async {
      // 1. Create index
      final res = await marchingEngine.indexes.create(
        displayName: 'test-index',
        description: 'This is a test index',
        metadata: const VertexAIIndexRequestMetadata(
          contentsDeltaUri: 'gs://vertex-ai/index',
          config: VertexAINearestNeighborSearchConfig(
            dimensions: 768,
            algorithmConfig: VertexAITreeAhAlgorithmConfig(),
          ),
        ),
      );
      // 2. Poll for operation completion (takes around 30min)
      VertexAIOperation operation = res;
      while (!operation.done) {
        print('Index creation operation not done yet...');
        await Future<void>.delayed(const Duration(seconds: 10));
        operation = await marchingEngine.indexes.operations.get(
          name: operation.name,
        );
      }
      expect(operation.error, isNull);
    });

    test('Test create index endpoint', () async {
      // 1. Create index endpoint
      final res = await marchingEngine.indexEndpoints.create(
        displayName: 'test-index-endpoint',
        description: 'This is a test index endpoint',
        publicEndpointEnabled: true,
      );
      // 2. Poll for operation completion (takes around 10s)
      VertexAIOperation operation = res;
      while (!operation.done) {
        print('Index endpoint creation operation not done yet...');
        await Future<void>.delayed(const Duration(seconds: 10));
        operation = await marchingEngine.indexEndpoints.operations.get(
          name: operation.name,
        );
      }
      expect(operation.error, isNull);
    });

    test('Test deploy index to endpoint', () async {
      // 1. Deploy index to endpoint
      final res = await marchingEngine.indexEndpoints.deployIndex(
        indexId: '5086059315115065344',
        indexEndpointId: '8572232454792806400',
        deployedIndexId: 'deployment1',
        deployedIndexDisplayName: 'test-deployed-index',
      );
      // 2. Poll for operation completion (takes around 30min)
      VertexAIOperation operation = res;
      while (!operation.done) {
        print('Index deployment operation not done yet...');
        await Future<void>.delayed(const Duration(seconds: 10));
        operation = await marchingEngine.indexEndpoints.operations.get(
          name: operation.name,
        );
      }
      expect(operation.error, isNull);
    });

    test('Test update index', () async {
      final res = await marchingEngine.indexes.update(
        id: '5086059315115065344',
        metadata: const VertexAIIndexRequestMetadata(
          contentsDeltaUri: 'gs://vertex-ai/index',
          isCompleteOverwrite: true,
        ),
      );
      expect(res, isNotNull);
    });

    test('Test list indexes', () async {
      final res = await marchingEngine.indexes.list();
      expect(res, isNotNull);
    });

    test('Test get index', () async {
      final res = await marchingEngine.indexes.get(id: '5209908304867753984');
      expect(res, isNotNull);
    });

    test('Test delete index', () async {
      final res =
          await marchingEngine.indexes.delete(id: '5209908304867753984');
      expect(res, isNotNull);
    });

    test('Test list index operations', () async {
      final res = await marchingEngine.indexes.operations
          .list(indexId: '5209908304867753984');
      expect(res, isNotNull);
    });

    test('Test list index endpoints', () async {
      final res = await marchingEngine.indexEndpoints.list();
      expect(res, isNotNull);
    });

    test('Test get index endpoint', () async {
      final res =
          await marchingEngine.indexEndpoints.get(id: '8572232454792806400');
      expect(res, isNotNull);
    });

    test('Test delete index endpoint', () async {
      final res =
          await marchingEngine.indexEndpoints.delete(id: '8572232454792806400');
      expect(res, isNotNull);
    });

    test('Test undeploy index from endpoint', () async {
      final res = await marchingEngine.indexEndpoints.undeployIndex(
        indexEndpointId: '8572232454792806400',
        deployedIndexId: 'deployment1',
      );
      expect(res, isNotNull);
    });
  });

  group('VertexAIMatchingEngineClient query tests', () {
    test('Test query index', () async {
      final machineEngineQuery = VertexAIMatchingEngineClient(
        authHttpClient: authClient,
        project: Platform.environment['VERTEX_AI_PROJECT_ID']!,
        rootUrl:
            'https://1451028425.europe-west1-706285145183.vdb.vertexai.goog/',
      );
      final res = await machineEngineQuery.indexEndpoints.findNeighbors(
        indexEndpointId: '8572232454792806400',
        deployedIndexId: 'deployment1',
        queries: const [
          VertexAIFindNeighborsRequestQuery(
            datapoint: VertexAIIndexDatapoint(
              datapointId: '10',
              featureVector: _queryVector,
            ),
            neighborCount: 3,
          ),
        ],
      );
      expect(res, isNotNull);
    });
  });
}

Future<AuthClient> _getAuthenticatedClient() async {
  final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
    json.decode(Platform.environment['VERTEX_AI_SERVICE_ACCOUNT']!),
  );
  return clientViaServiceAccount(
    serviceAccountCredentials,
    [VertexAIGenAIClient.cloudPlatformScope],
  );
}

const _queryVector = [
  -0.0024800552055239677,
  0.011974085122346878,
  0.027945270761847496,
  0.06089121848344803,
  0.01591639779508114,
  0.045949868857860565,
  -0.012206366285681725,
  0.026397397741675377,
  -0.02571168914437294,
  -0.0022428107913583517,
  0.017314476892352104,
  0.05456288158893585,
  0.035699039697647095,
  -0.02135152369737625,
  -0.022606346756219864,
  -0.004925490356981754,
  -0.04399697855114937,
  -0.024715086445212364,
  -0.006850498262792826,
  0.01790747046470642,
  -0.05940520390868187,
  -0.006281573325395584,
  -0.014405393972992897,
  -0.026017308235168457,
  0.014548663049936295,
  -0.0731135904788971,
  0.024497421458363533,
  -0.027612458914518356,
  -0.029020294547080994,
  -0.06312020123004913,
  -0.003921786323189735,
  -0.017137227579951286,
  0.012081332504749298,
  -0.02097455784678459,
  0.014852325432002544,
  0.053726162761449814,
  -0.03733977675437927,
  0.02199450694024563,
  -0.0018198131583631039,
  0.0499347485601902,
  -0.01654892787337303,
  -0.0491509735584259,
  0.020115764811635017,
  0.011543355882167816,
  0.010533302091062069,
  -0.003705954644829035,
  -0.021334081888198853,
  0.06394882500171661,
  0.06690078228712082,
  -0.048335202038288116,
  -0.01955878920853138,
  0.020723478868603706,
  -0.00039762884262017906,
  0.048672866076231,
  0.024126645177602768,
  0.04419830068945885,
  -0.06521899998188019,
  -0.033290475606918335,
  -0.01575658842921257,
  0.01642526686191559,
  0.02032945491373539,
  -0.04161004722118378,
  0.01441210974007845,
  -0.0410119853913784,
  -0.06563021242618561,
  0.007922261953353882,
  -0.028644349426031113,
  0.017991654574871063,
  -0.0077970284037292,
  -0.025995980948209763,
  0.011249588802456856,
  -0.00045249194954521954,
  -0.02123924158513546,
  0.021377315744757652,
  0.05281722545623779,
  -0.02869519591331482,
  0.014597243629395962,
  0.01738382689654827,
  0.017890606075525284,
  -0.07110098749399185,
  -0.01999991573393345,
  -0.00877347495406866,
  -0.05301406607031822,
  -0.11461994796991348,
  -0.06401617079973221,
  0.06658251583576202,
  -0.001995210302993655,
  0.013316542841494083,
  -0.020424021407961845,
  0.037054046988487244,
  -0.040274158120155334,
  0.023708872497081757,
  0.037896133959293365,
  0.020479658618569374,
  -0.01741095632314682,
  -0.05057836323976517,
  -0.008709455840289593,
  -0.013266217894852161,
  0.015497623942792416,
  0.01205222774296999,
  -0.027619006112217903,
  -0.10722710192203522,
  -0.005731775891035795,
  -0.07026918232440948,
  0.04038692265748978,
  -0.05040004104375839,
  0.005217043682932854,
  0.03388015553355217,
  0.010141142643988132,
  -0.07109049707651138,
  0.012917617335915565,
  -0.022699229419231415,
  -0.027181023731827736,
  0.01369607076048851,
  0.05940553918480873,
  -0.0666455626487732,
  0.004041127394884825,
  0.05400310084223747,
  -0.005153415258973837,
  0.021585319191217422,
  -0.03905688598752022,
  -0.0263311006128788,
  0.01328785065561533,
  0.00648899283260107,
  -0.01907315105199814,
  0.019168950617313385,
  0.09318007528781891,
  0.05195644870400429,
  0.01619238220155239,
  0.04146619886159897,
  0.0936182364821434,
  -0.022216904908418655,
  0.01723639667034149,
  -0.029653336852788925,
  0.08174880594015121,
  0.01754760928452015,
  -0.023688282817602158,
  0.02213711477816105,
  0.030211031436920166,
  0.05241619795560837,
  -0.08753107488155365,
  0.012492592446506023,
  -0.007995668798685074,
  0.04056641831994057,
  -0.055074967443943024,
  -0.030395345762372017,
  0.006586231756955385,
  -0.0278791394084692,
  -0.04829850792884827,
  -0.016373807564377785,
  -0.05235663801431656,
  0.015281729400157928,
  -0.010130900889635086,
  0.06573318690061569,
  0.05475528538227081,
  0.05164555460214615,
  0.006315293721854687,
  0.019746508449316025,
  0.015135163441300392,
  -0.031136205419898033,
  0.007764772046357393,
  0.0394541472196579,
  -0.02604949288070202,
  0.013066614978015423,
  0.023597221821546555,
  0.006964786443859339,
  -0.041713815182447433,
  0.009692543186247349,
  -0.01894967071712017,
  0.02710210159420967,
  0.06985951215028763,
  -0.11547199636697769,
  0.026909882202744484,
  -0.05686219781637192,
  0.07252556830644608,
  0.02729402855038643,
  0.008035331964492798,
  0.024488260969519615,
  0.002778689842671156,
  0.011325910687446594,
  -0.003569392953068018,
  -0.0850648581981659,
  0.0012582677882164717,
  -0.040039319545030594,
  -0.03386136144399643,
  0.00014740921324118972,
  -0.021747155115008354,
  0.010006153024733067,
  -0.045477915555238724,
  0.03555833175778389,
  0.004154199734330177,
  0.027085134759545326,
  -0.004759603179991245,
  -0.06851977109909058,
  -0.012431585229933262,
  -0.04602782800793648,
  0.052711136639118195,
  -0.08390163630247116,
  0.04075220972299576,
  0.030154278501868248,
  -0.02538658119738102,
  -0.06528583914041519,
  0.013150053098797798,
  0.04211396723985672,
  -0.04961792379617691,
  0.010408340021967888,
  -0.018248483538627625,
  0.01874774694442749,
  -0.029981963336467743,
  0.03500630334019661,
  0.008376826532185078,
  0.005190200638025999,
  0.05301978066563606,
  0.005912765394896269,
  0.006089750677347183,
  0.004957679659128189,
  0.032940641045570374,
  -0.06675024330615997,
  -0.0792369619011879,
  -0.03757181763648987,
  0.014747879467904568,
  0.021590597927570343,
  -0.004220806993544102,
  0.0058377147652208805,
  0.025445397943258286,
  0.04735690727829933,
  0.025496503338217735,
  -0.0009749596938490868,
  -0.03635849058628082,
  0.05388989299535751,
  0.022338273003697395,
  -0.014873513951897621,
  -0.04598985239863396,
  -0.01964334212243557,
  -0.002764167496934533,
  0.06323042511940002,
  -0.00022570922737941146,
  0.025602353736758232,
  -0.08158840239048004,
  0.033581968396902084,
  -0.010399993509054184,
  0.022933878004550934,
  -0.04645109176635742,
  0.0237208753824234,
  -0.003838959615677595,
  0.030994132161140442,
  -0.0581846758723259,
  0.042504776269197464,
  0.009096813388168812,
  -0.028246747329831123,
  0.057335738092660904,
  -0.021672362461686134,
  0.016617396846413612,
  0.02242114767432213,
  0.04753721505403519,
  -0.03262138366699219,
  0.0014356492320075631,
  0.052940450608730316,
  -0.03302508965134621,
  0.03374477103352547,
  -0.02883862517774105,
  -0.03039146587252617,
  0.020496999844908714,
  0.06553924083709717,
  0.015572815202176571,
  -0.008528808131814003,
  -0.04120403155684471,
  -0.042944908142089844,
  0.06550800800323486,
  -0.00409502349793911,
  -0.019560927525162697,
  0.0025754491798579693,
  0.049757979810237885,
  0.029423275962471962,
  0.011083927005529404,
  0.050855644047260284,
  -0.04935210570693016,
  0.03638442978262901,
  -0.052799563854932785,
  0.07322375476360321,
  0.051303647458553314,
  -0.032500140368938446,
  0.019702143967151642,
  0.05000250041484833,
  0.005088430363684893,
  0.017879273742437363,
  -0.019979150965809822,
  0.025685083121061325,
  -0.028702659532427788,
  0.007295092102140188,
  0.04584210366010666,
  -0.07941862940788269,
  0.02022925391793251,
  0.05224103108048439,
  0.015263560228049755,
  0.0002274672588100657,
  0.03551832213997841,
  -0.029143039137125015,
  -0.016852524131536484,
  0.033210039138793945,
  0.015557453967630863,
  -0.0004994983319193125,
  -0.019271982833743095,
  -0.030236605554819107,
  -0.05725082755088806,
  -0.010165062732994556,
  0.019357409328222275,
  0.027202516794204712,
  0.01839538849890232,
  -0.019694624468684196,
  0.02678288146853447,
  -0.044801242649555206,
  0.015726404264569283,
  0.02533598057925701,
  -0.027300124987959862,
  0.030965549871325493,
  0.01383476797491312,
  0.025441769510507584,
  -0.042588166892528534,
  -0.0026665041223168373,
  -0.07306212931871414,
  0.04228546842932701,
  0.07770076394081116,
  0.02618120238184929,
  0.01646341010928154,
  -0.04739517718553543,
  -0.08538003265857697,
  0.040878623723983765,
  0.050099264830350876,
  -0.012263220734894276,
  -0.03874794393777847,
  0.02525949664413929,
  -0.04332829639315605,
  -0.00814410112798214,
  0.04538974538445473,
  -0.04799098148941994,
  0.010895933955907822,
  0.023221634328365326,
  0.018915975466370583,
  -0.08099763095378876,
  -0.037038736045360565,
  -0.038237277418375015,
  -0.0205315463244915,
  -0.034528762102127075,
  -0.01136486791074276,
  0.01599818654358387,
  -0.023073730990290642,
  -0.011987966485321522,
  -0.06666819006204605,
  -0.04086934030056,
  0.002453841967508197,
  0.055486876517534256,
  0.013495233841240406,
  0.016096634790301323,
  0.01632685586810112,
  0.0046924808993935585,
  -0.0013824260095134377,
  -0.022637294605374336,
  0.053107455372810364,
  0.004315677098929882,
  -0.02178102359175682,
  0.017118530347943306,
  -0.03783629834651947,
  -0.010677210986614227,
  0.016758006066083908,
  -0.0037163058295845985,
  -0.02830849587917328,
  -0.028290648013353348,
  0.011388111859560013,
  -0.06282684952020645,
  0.002664626343175769,
  0.001676127314567566,
  0.014519261196255684,
  -0.021564491093158722,
  -0.027759229764342308,
  0.022160736843943596,
  -0.05039668455719948,
  0.019299058243632317,
  -0.003910744562745094,
  0.023026909679174423,
  -0.014358281157910824,
  0.040930043905973434,
  -0.02965562790632248,
  0.0315079465508461,
  0.009793383069336414,
  -0.011312074959278107,
  0.026616903021931648,
  0.08185574412345886,
  0.0022060233168303967,
  0.03195205330848694,
  0.017995746806263924,
  0.04716493934392929,
  0.043085839599370956,
  -0.02036077342927456,
  0.03734202682971954,
  0.019890712574124336,
  -0.05439202859997749,
  -0.08098692446947098,
  -0.03921710327267647,
  -0.016108626499772072,
  0.028868334367871284,
  -0.01334142405539751,
  -0.04652391001582146,
  -0.055355172604322433,
  0.00672161253169179,
  -0.015201116912066936,
  -0.027707237750291824,
  0.03995480760931969,
  0.028925718739628792,
  -0.007712054066359997,
  0.0228127371519804,
  -0.03518705815076828,
  -0.00964331068098545,
  -0.003235805546864867,
  0.07459256798028946,
  -0.054491519927978516,
  -0.010547894984483719,
  -0.05564255267381668,
  0.017967883497476578,
  -0.023240119218826294,
  0.0008635363774374127,
  -0.026240376755595207,
  -0.07990437746047974,
  0.025640642270445824,
  -0.009579784236848354,
  -0.0015484221512451768,
  -0.05469866469502449,
  -0.01371675543487072,
  -0.053961653262376785,
  0.020929858088493347,
  0.011524469591677189,
  -0.05228453502058983,
  0.038667384535074234,
  -0.01055141631513834,
  -0.041942697018384933,
  -0.029565278440713882,
  0.06928738951683044,
  0.1073240265250206,
  -0.026453327387571335,
  -0.03961186856031418,
  -0.03256576135754585,
  -0.021278824657201767,
  0.018629232421517372,
  0.04511110484600067,
  -0.012895888648927212,
  -0.013234605081379414,
  -0.06024298444390297,
  -0.00470823934301734,
  -0.023729337379336357,
  -0.03319356217980385,
  -0.033604737371206284,
  -0.019526876509189606,
  -0.03432648256421089,
  0.06283165514469147,
  0.0022637846413999796,
  0.07177982479333878,
  0.016291163861751556,
  -0.03822924196720123,
  -0.046136315912008286,
  -0.010122058913111687,
  -0.026826607063412666,
  0.030277421697974205,
  0.0012080231681466103,
  0.04549718648195267,
  -0.028757764026522636,
  0.015382646583020687,
  0.04650441184639931,
  0.009145055897533894,
  -0.03695225343108177,
  0.03564176335930824,
  -0.054017260670661926,
  0.053990766406059265,
  -0.03894525021314621,
  0.005253234412521124,
  0.05727563053369522,
  0.016917597502470016,
  0.0015583543572574854,
  0.035989921540021896,
  -0.00906539149582386,
  -0.014243338257074356,
  -0.03303677216172218,
  -0.01067740935832262,
  -0.008197851479053497,
  -0.05057824030518532,
  0.008696588687598705,
  0.04489292576909065,
  -0.008058791980147362,
  -0.023300092667341232,
  0.040308475494384766,
  0.0010585372801870108,
  0.01096348650753498,
  -0.06801032274961472,
  -0.00025523806107230484,
  -0.011782528832554817,
  0.030658317729830742,
  -0.02044806070625782,
  -0.001490660011768341,
  -0.019346261397004128,
  0.032130707055330276,
  -0.034276120364665985,
  -0.06216953322291374,
  0.0009086608188226819,
  0.001522677717730403,
  -0.012745819054543972,
  0.06908354163169861,
  -0.0035166162997484207,
  -0.018514111638069153,
  -0.039288099855184555,
  -0.0444314107298851,
  0.03754890337586403,
  0.016863422468304634,
  -0.03534917160868645,
  -0.003182257292792201,
  -0.04774448275566101,
  -0.00003124616341665387,
  -0.10518063604831696,
  -0.004144659731537104,
  0.0723867118358612,
  -0.0031207804568111897,
  0.013072462752461433,
  -0.048622481524944305,
  -0.033812060952186584,
  0.004568304400891066,
  -0.0031037137378007174,
  0.021052075549960136,
  0.04156983643770218,
  0.03892498463392258,
  -0.011406195349991322,
  -0.031035030260682106,
  0.011150837875902653,
  -0.011662237346172333,
  0.05525480583310127,
  -0.03298760950565338,
  -0.031118126586079597,
  0.08421474695205688,
  -0.02164381556212902,
  0.023803481832146645,
  -0.012235553935170174,
  0.01834927499294281,
  0.05319342762231827,
  -0.0201859287917614,
  -0.012603869661688805,
  0.023757725954055786,
  0.021485626697540283,
  0.012704837135970592,
  0.02149340882897377,
  0.02025606669485569,
  0.006970172747969627,
  0.050382718443870544,
  -0.028631050139665604,
  -0.003874230431392789,
  -0.060862522572278976,
  -0.0681929886341095,
  0.03328116983175278,
  -0.0003696992062032223,
  -0.04718751460313797,
  -0.06874881684780121,
  -0.024884505197405815,
  0.011152289807796478,
  -0.02182626910507679,
  0.009133966639637947,
  0.016513297334313393,
  0.009121187962591648,
  -0.03590567782521248,
  0.031725939363241196,
  0.003005493897944689,
  0.016160182654857635,
  0.02399451471865177,
  -0.017237335443496704,
  0.01866758242249489,
  -0.019074972718954086,
  -0.0488954596221447,
  -0.029238546267151833,
  -0.021969163790345192,
  0.03000270202755928,
  -0.012111065909266472,
  -0.061692509800195694,
  -0.027968399226665497,
  0.02743874490261078,
  0.007777548860758543,
  0.015492431819438934,
  -0.005347430240362883,
  -0.018200334161520004,
  0.0018336826469749212,
  -0.031607042998075485,
  -0.014118785038590431,
  -0.024861887097358704,
  -0.017011569812893867,
  -0.03169884905219078,
  -0.0850626602768898,
  0.029640695080161095,
  -0.07870057225227356,
  -0.011963256634771824,
  0.006744022481143475,
  -0.04094612970948219,
  -0.004237143788486719,
  0.01201427262276411,
  -0.05417366325855255,
  0.04515045881271362,
  -0.03326345607638359,
  0.012644425965845585,
  -0.026208844035863876,
  0.04211442172527313,
  -0.011998665519058704,
  -0.006546241696923971,
  0.0011108559556305408,
  0.08723857253789902,
  0.05843894183635712,
  0.040107037872076035,
  0.028628408908843994,
  0.002568240510299802,
  0.01729537546634674,
  0.005429181270301342,
  -0.02222994901239872,
  -0.007678688503801823,
  -0.026843709871172905,
  -0.01726338267326355,
  -0.0014378676423802972,
  0.03453582897782326,
  0.005992847960442305,
  -0.012618916109204292,
  0.09048930555582047,
  -0.004347036127001047,
  -0.05761748179793358,
  -0.024218415841460228,
  -0.0617549791932106,
  0.023912576958537102,
  0.048499371856451035,
  0.002885707886889577,
  -0.029988480731844902,
  -0.01094681117683649,
  -0.018467770889401436,
  0.003714068327099085,
  -0.058079030364751816,
  0.017040394246578217,
  -0.039894089102745056,
  -0.030635381117463112,
  0.044455066323280334,
  0.04558039829134941,
  0.04559404402971268,
  0.020578967407345772,
  -0.0054467832669615746,
  -0.00569724990054965,
  0.009905865415930748,
  -0.011255532503128052,
  -0.0355696864426136,
  -0.034046903252601624,
  -0.002546388655900955,
  0.0034123039804399014,
  -0.012156737968325615,
  0.0527615025639534,
  -0.032744478434324265,
  -0.046668991446495056,
  -0.03462834656238556,
  -0.06650368869304657,
  -0.008561598137021065,
  -0.0013868717942386866,
  0.06080976128578186,
  0.0077654700726270676,
  0.003287557978183031,
  0.05465131253004074,
  0.004132724367082119,
  0.024199068546295166,
  0.05864977836608887,
  -0.06225745007395744,
  0.0057786013931035995,
  -0.007371222134679556,
  -0.005587731022387743,
  -0.00950106605887413,
  -0.061786990612745285,
  0.008341703563928604,
  -0.04203549027442932,
  -0.03493040055036545,
  -0.02666497603058815,
  0.008635095320641994,
  -0.0005944097065366805,
  0.034384552389383316,
  0.06463247537612915,
  0.030862923711538315,
  0.038226742297410965,
  -0.00971216894686222,
  -0.04456645995378494,
  0.021693125367164612,
  -0.013434921391308308,
  0.04909699410200119,
  -0.028396733105182648,
  0.01156967505812645,
  -0.011123130097985268,
  -0.0031161142978817225,
  0.016380202025175095,
  0.015161557123064995,
  0.02891436032950878,
  -0.053235702216625214,
  0.02260618843138218,
  -0.021886402741074562,
  -0.05016421526670456,
  -0.0190590750426054,
  -0.005225166212767363,
  0.0320899523794651,
  0.019669990986585617,
  -0.013529667630791664,
  0.016441943123936653,
  0.05976942181587219,
  0.023295745253562927,
  0.03328859061002731,
  -0.044952381402254105,
  -0.06350108981132507,
  0.0034671607427299023,
  -0.01289446372538805,
  -0.04644192010164261,
  -0.014127887785434723,
  0.010741163976490498,
  0.030758243054151535,
  0.037426527589559555,
  -0.019230302423238754,
  0.04674021899700165,
  -0.10073813796043396,
  -0.02519753761589527,
  0.0244305282831192,
  0.010897213593125343,
  0.017850957810878754,
  0.05721067264676094,
  0.0034028352238237858,
  -0.05515863001346588,
  -0.045212119817733765,
  0.005976893939077854,
  0.004804182797670364,
  -0.03706206753849983,
  -0.043186623603105545,
  0.03596680611371994,
  -0.029261885210871696,
  0.029298892244696617,
  0.038443610072135925,
  0.04970880225300789,
  -0.02848917432129383,
  -0.008567516691982746,
  0.027900034561753273,
  0.03967684507369995,
  -0.004614111967384815,
  0.011680900119245052,
  0.011586959473788738,
  0.013510816730558872,
  -0.019214434549212456,
  -0.007085992489010096,
  -0.022214235737919807,
  0.0009897889103740454,
  0.05701182782649994,
  -0.019148552790284157,
  0.0013918313197791576,
  0.0021684300154447556,
  -0.044678740203380585,
  0.0040362002328038216,
  0.04208571836352348,
  -0.004585193935781717,
  -0.009162068367004395,
  0.0646393671631813,
  0.023202434182167053,
  0.031634483486413956,
  -0.04858662188053131,
  0.03577597439289093,
  -0.013750282116234303,
  -0.016435980796813965,
  -0.04169601947069168,
  0.026427248492836952,
  0.04319629445672035,
  -0.007710671983659267,
  -0.00981274526566267,
  0.006554502993822098
];