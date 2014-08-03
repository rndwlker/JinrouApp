//
//  UserViewController.m
//  Jinrou
//
//  Created by KenjiMatsuda on 2014/07/21.
//  Copyright (c) 2014年 KenjiMatsuda. All rights reserved.
//

#import "UserViewController.h"
#import "FMDatabase.h"

@interface UserViewController ()
{
    FMDatabase* db;
}
- (void)createDatabase;
- (void)insertToTabel;
- (void)selectDatabase;
- (void)deleteDatabase;
@property (weak, nonatomic) IBOutlet UITextField *userName;
- (IBAction)recodeUserName:(UIButton *)sender;
- (IBAction)showUserName:(UIButton *)sender;
@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // データベースの初期設定
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"Jinrou.db"]];

    [self createDatabase];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TODO:　関数化、DAOなど使用する


// データベースを作成するメソッド
// テーブルのカラムは、「ユーザーid、ユーザー名、点数、作成日時、更新日時、削除フラグ」をあらわす
- (void)createDatabase
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_info (id INTEGER PRIMARY KEY , user_name TEXT, score INTEGER, created_time NUMERIC, modified_time NUMERIC, exist_flag NUMERIC); ";
    [db open];
    [db executeUpdate:sql];
    [db close];
}


// テーブルにデータを挿入する
// ここでは、ユーザー名を登録している
- (void)insertToTabel
{
    if (![_userName.text isEqualToString: @"" ]) {
        NSString*   sql1 = @"INSERT INTO user_info (user_name) VALUES (?)";
        [db open];
        [db executeUpdate:sql1, _userName.text];
        [db close];
    }
}


// テーブルのデータを削除する (まだ使っていない)
- (void)deleteDatabase
{

}


// テキスト画面を終了して通常画面に戻る
- (IBAction)tapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


// テーブルのSELECT文
- (void)selectDatabase
{
    NSString *select_sql= @"SELECT id, user_name FROM user_info;";
    [db open];
    FMResultSet *result = [db executeQuery:select_sql];
    while ( [result next] ) {
        int      result_id   = [result intForColumn:@"id"];
        NSString *result_name = [result stringForColumn:@"user_name"];
        NSLog(@"recode id[%d] user_name [%@]", result_id , result_name);
    }
    [db close];
    
}

- (IBAction)recodeUserName:(UIButton *)sender {
    [self insertToTabel];
}
// テーブルのデータを表示する
- (IBAction)showUserName:(UIButton *)sender {
     [self selectDatabase];
}
@end